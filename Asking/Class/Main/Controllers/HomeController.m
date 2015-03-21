//
//  HomeController.m
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "HomeController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyContact.h"


#import "MBProgressHUD.h"
#import "SBJson.h"
#import "BubbleTextView.h"
#import "LvesChatBaseCell.h"
#import "FunctionCell.h"
#import "CustomSpeechView.h"
#import "SpeechParseEngine.h"
#import "MapMainController.h"
#import "WeatherTools.h"
#import "MusicController.h"
#import "MusicPlayerManager.h"
#import "DianPingTools.h"
#import "DianPingListController.h"
#import "BusinessDetailController.h"
#import "WeatherController.h"
#import "AddressBookTool.h"
#import "NewsMainController.h"


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


typedef enum {
    RotateStateStop,
    RotateStateRunning,
}RotateState;


@interface HomeController ()<UITableViewDataSource,UITableViewDelegate,IFlySpeechRecognizerDelegate,CustomeSpeechDelegate,FunctionCellCardDelegate,MusicPlayerDelegate>
{
    ///
    UITableView *_mainTableView;
    ///录音弹出视图
    CustomSpeechView *_speechView;
    
    ///开始录音按钮
    UIButton *_startBtn;
    ///开始语音识别的声音资源
    SystemSoundID shortSound;
    
    MBProgressHUD *_hud;
    ///语音识别
    IFlySpeechUnderstander *_iFlySpeechUnderstander;
    ///数据源
    NSMutableArray *_dataArray;
    ///蒙版
    UIView *_maskView;
    ///旋转视图的旋转角度
    CGFloat imageviewAngle;
    ///旋转视图
    UIImageView *rotateImageView;
    ///旋转状态
    RotateState rotateState;
    ///当前音乐模型
    MusicModel *currentMusicModel;
    ///当前播放歌曲
    Song *_currentSong;
    MusicPlayerManager *audioManager;
}

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.. 使用语义前需要首先确保对应的appid已经开通语义功能
    [self configIFlySpeech];
    //2. 初始化声音资源
    [self initAudioFile];
    //3. 初始化UI
    [self buildUI];
    //4. 初始化语音播放器
    [self buildAudioManager];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置代理
    audioManager.delegate=self;
    
    _currentSong=audioManager.currentSong;
    if (_currentSong) {
        [rotateImageView sd_setImageWithURL:[NSURL URLWithString:_currentSong.cover] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        //正在播放
        if (audioManager.musicPlayer.state==STKAudioPlayerStatePlaying||audioManager.musicPlayer.state==STKAudioPlayerStateRunning) {
            if (rotateState!=RotateStateRunning) {
                rotateState=RotateStateRunning;
                [self rotateAnimate];
            }
        }else{
            rotateState=RotateStateStop;
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //暂停旋转动画
    [self stopRotateAnimate];
}

#pragma mark - 初始化

#pragma mark 初始化视图
-(void)buildUI{
    //1.添加TableView
    [self buildTableView];
    //2. 添加开始语音识别按钮
    [self buildStartButton];
    //3. 添加ActionSheet视图
    [self buildActicityView];
    //4.初始化蒙版
    _maskView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _maskView.backgroundColor=[UIColor blackColor];
    _maskView.alpha=0.5f;
    _maskView.userInteractionEnabled=NO;
    

}
#pragma mark  初始化语音播放器
-(void) buildAudioManager{
    audioManager=[MusicPlayerManager sharedManager];
    audioManager.delegate=self;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}
#pragma mark  远程控制
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [audioManager play];
                [self rotateImageViewAnimate];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [audioManager playpreviousSong];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [audioManager playNextSong];
                break;
            case UIEventSubtypeRemoteControlPause:
                [audioManager pause];
                rotateState=RotateStateStop;
                break;
            case UIEventSubtypeRemoteControlPlay :
                [audioManager play];
                break;
            default:
                break;
        }
    }
}


/*添加tableView*/
-(void)buildTableView{
    //0.
    self.title=@"语音助手";
    self.view.backgroundColor=kChatBackColor;
    //1. 添加tableview
    _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kpadding)];
    _mainTableView.dataSource=self;
    _mainTableView.delegate=self;
    _mainTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    _mainTableView.backgroundColor=kChatBackColor;
    [self.view addSubview:_mainTableView];
    
    //2. 设置数据源
    _dataArray=[NSMutableArray array];
    
}

/*添加活动面板*/
-(void)buildActicityView{
    //1. 初始化ActionSheet视图
    _speechView=[[CustomSpeechView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kActivityViewH)];
    _speechView.delegate=self;
    [self.view addSubview:_speechView];
    
}

/*添加语音识别按钮*/
-(void)buildStartButton{
    _startBtn=[[UIButton alloc] init];
    [_startBtn setCenter:CGPointMake(kScreenWidth/2.f, kScreenHeight-kBtnSize*0.5f-kpadding)];
    [_startBtn setBounds:CGRectMake(0, 0, kBtnSize, kBtnSize)];
    [_startBtn setImage:[UIImage imageNamed:@"voice_press.png"] forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(soundBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_startBtn];
}

#pragma mark  添加 RightBarButtonItem
-(void)buildBarButtonItem{
    if (rotateImageView==nil) {
        rotateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
        rotateImageView.autoresizingMask = UIViewAutoresizingNone;
        rotateImageView.contentMode = UIViewContentModeScaleToFill;
        rotateImageView.bounds=CGRectMake(0, 0, 40, 40);
        rotateImageView.layer.masksToBounds=YES;
        rotateImageView.layer.cornerRadius=20.f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button addSubview:rotateImageView];
        [button addTarget:self action:@selector(toMusicController:) forControlEvents:UIControlEventTouchUpInside];
        rotateImageView.center = button.center;
        UIBarButtonItem  *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barItem;
    }
}
#pragma mark 跳转到 Music Controller
-(void)toMusicController:(id)sender{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicController *musicController =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"MusicController"];
    musicController.currentSong=_currentSong;
    //暂停旋转动画
    [self stopRotateAnimate];
    [self presentViewController:musicController animated:YES completion:nil];
}
#pragma mark 暂停旋转动画
-(void)stopRotateAnimate{
    rotateState=RotateStateStop;
}

#pragma mark  旋转ImageView
- (void)rotateImageViewAnimate {
    if (rotateState==RotateStateStop) {
        rotateState=RotateStateRunning;
        [self rotateAnimate];
    }else{
        rotateState=RotateStateStop;
    }
}


#pragma mark 循环旋转动画
-(void)rotateAnimate{
    imageviewAngle+=30;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        rotateImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(imageviewAngle));
    } completion:^(BOOL finished) {
        if (rotateState==RotateStateRunning) {
            [self rotateAnimate];
        }
    }];
}


#pragma mark - 语音识别
/*初始化语义理解*/
-(void)configIFlySpeech{
    
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
    [_iFlySpeechUnderstander setParameter:@"sms" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iFlySpeechUnderstander setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySpeechUnderstander setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
    [_iFlySpeechUnderstander setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    
    //创建上传对象
    IFlyDataUploader *uploader = [[IFlyDataUploader alloc] init];
    //获取联系人集合
    IFlyContact *iFlyContact = [[IFlyContact alloc] init];
    NSString *contactList = [iFlyContact contact];
    //设置参数
    [uploader setParameter:@"uup" forKey:@"subject"];
    [uploader setParameter:@"contact" forKey:@"dtt"];
    //启动上传
    [uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error) {
        //接受返回的grammerID和error
        NSLog(@"%@",grammerID);
//        [self onUploadFinished:grammerID error:error];
    }name:@"contact" data: contactList];
    
    
    
}


#pragma mark  声音
/*初始化语音 start.caf*/
- (void)initAudioFile{
    // Get the full path of Sound12.aif
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"start"
                                                          ofType:@"caf"];
    // If this file is actually in the bundle...
    if (soundPath) {
        // Create a file URL with this path
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        // Register sound file located at that URL as a system sound
        OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&shortSound);
        
        
        if (err != kAudioServicesNoError)
            NSLog(@"error");
            //NSLog(@"Could not load %@, error code: %d", soundURL, err);
    }
    
}


#pragma mark 点击按钮触发事件
/*语音按钮点击*/
-(void)soundBtnClick:(id)sender{
    self.navigationController.navigationBarHidden=YES;
    //0.停止音乐
    [audioManager stop];
    
    
    //1. 移除开始录音按钮
    [_startBtn removeFromSuperview];
    
    //添加一个蒙版
    [self.view insertSubview:_maskView belowSubview:_speechView];
    
    
    //2.1. 播放开始声音
    // AudioServicesPlaySystemSound(shortSound);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //震动
    
    //3. 启动识别服务
    [_iFlySpeechUnderstander startListening];
   
    //4. 弹出actionsheet视图动画
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _speechView.frame=CGRectMake(0, kScreenHeight-kActivityViewH, kScreenWidth, kActivityViewH);
        [_speechView.speechBtn setCenter:CGPointMake(kScreenWidth/2.f, kActivityViewH*(2/3.f)+10.f)];
        
    } completion:^(BOOL finished)
     {
         //开始录音动画
         [_speechView startSpeechAnimate];
     }];
}



/*移除ActionSheetView*/
-(void)removeActionSheet{
    
    //3. 移除actionsheet视图
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //1.移除蒙版
        [_maskView removeFromSuperview];
        //2. 添加开始录音按钮
        [self.view addSubview:_startBtn];
        _speechView.frame=CGRectMake(0,kScreenHeight, kScreenWidth, kActivityViewH);
        [_speechView.speechBtn setCenter:CGPointMake(kScreenWidth/2.f, kActivityViewH-kBtnSpeechSize/2.f-kpadding)];
    } completion:^(BOOL finished)
     {
         
        self.navigationController.navigationBarHidden=NO;
         
     }];
}

#pragma mark SpeechView delegate
/*语音完成*/
-(void)customSpeechViewCancel{
    //语音识别结束
    [_iFlySpeechUnderstander stopListening];
    //移除底部视图
    [self removeActionSheet];
}
/*语音取消*/
-(void)customSpeechViewDelete{
    //语音识别结束
    [_iFlySpeechUnderstander cancel];
    //移除底部视图
    [self removeActionSheet];
}

-(void)onEndOfSpeech{
    NSLog(@"%@",@"ok");

}



#pragma mark - SpeechTableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    id model=_dataArray[indexPath.section];
    
    if ([model isKindOfClass:[FunctionModel class]]) { //功能
        height=[FunctionCell heightForFunctionCell:model];
    }else{
        height=[LvesChatBaseCell heightForCell:model];
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id model=_dataArray[indexPath.section];
    if ([model isKindOfClass:[FunctionModel class]]) { //1. 功能
        static NSString * FunctionIdentifier = @"FunctionCell";
        FunctionCell *cell=[tableView dequeueReusableCellWithIdentifier:FunctionIdentifier];
        if (cell == nil)
        {
            cell = [[FunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FunctionIdentifier];
            cell.delegate=self;
        }
        [cell setFunctionModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{                                              //2. 智能机器人
        static NSString * showUserInfoCellIdentifier = @"Cell";
        LvesChatBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
        if (cell == nil)
        {
            cell = [[LvesChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
        }
        [cell setModel:model];
        return cell;
    }
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
}


#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id model=_dataArray[indexPath.section];
    
    if ([model isKindOfClass:[FunctionModel class]]) {
        FunctionModel *funModel=(FunctionModel *)model;
        if (funModel.type==FunctionTypeWeather) {    //点击天气卡片
            UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WeatherController *weatherController =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"WeatherController"];
            weatherController.weatherModel=funModel.weatherModel;
            [self.navigationController pushViewController:weatherController animated:YES];
        }
    }

}



#pragma mark - 语义识别回调

/*语义识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void) onResults:(NSArray *)results isLast:(BOOL)isLast {
    
    if (results.count > 0)
    {
        NSDictionary *dic = results[0];
        
        NSMutableString *keyString = [[NSMutableString alloc] init];
        
        for (NSString *key in dic)
        {
            [keyString appendFormat:@"%@",key];
        }
        
        NSDictionary *json = [keyString JSONValue];
        //判断语音类型
        NSString *service= json[@"service"];
        
        if (service==nil||[service isEqualToString:@"openQA"]) {
            
            NSString *text=json[@"text"];
            NSRange newsRange=[text rangeOfString:@"新闻"];
            if (newsRange.length>0) {
                self.title=text;
                UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MusicController *newsController =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"NewsMainController"];
                [self.navigationController pushViewController:newsController animated:YES];
                return;
            }
            //1. 显示语音信息
            MessageModel *newModel=[[MessageModel alloc] init];
            newModel.type=MessageBodyType_Text;
            newModel.isSender=YES;
            newModel.content=text;
            [_dataArray addObject:newModel];
            [_mainTableView reloadData];
            //1.1 滚动到底部
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection:  _dataArray.count-1];
            [_mainTableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];

        }else{
            //2. 解析语音结果
            self.title=json[@"text"];
            [self parseVoice:json];
        }
    }
    
}
-(void) onError:(IFlySpeechError*) error
{
    NSLog(@"语音解析错误::%@",[error errorDesc]);
}


#pragma mark  - 处理语音
#pragma mark 处理语音
-(void)parseVoice:(NSDictionary *)result{
    //解析返回的结果
    SpeechParseEngine *engine=[[SpeechParseEngine alloc] init];
    id model=[engine parseSpeechByDictionary:result];
    
    //添加到数组
    if(model!=nil){
        
        if ([model isKindOfClass:[FunctionModel class]]) {
            __block FunctionModel *functionModel=model;
            
            if (functionModel.type==FunctionTypeWeather) {  //天气
                //获得天气信息
                [WeatherTools getWeatherByCityName:functionModel.cityName
                                        andSuccess:^(WeatherModel *weatherModel)
                 {
                     weatherModel.cityName=functionModel.cityName;
                     functionModel.weatherModel=weatherModel;
                     
                     [_dataArray addObject:model];
                     [_mainTableView reloadData];
                     //滚动到底部
                     NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection:_dataArray.count-1];
                     [_mainTableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                 } andFialure:^(NSError *error) {
                     NSLog(@"获得天气失败");
                 }];
                return;

            }else if (functionModel.type==FunctionTypeMusic){   //音乐
                //1. 获得要请求的音乐信息
                currentMusicModel=functionModel.musicModel;
                NSString *artist=currentMusicModel.artist;
                NSString *songName=currentMusicModel.songName;
                NSLog(@"%@---》%@",artist,songName);
                //2. 请求Music信息
                
                [MusicTools getMusicByArtist:artist andSong:songName andSuccess:^(MusicModel *musicModel) {
                    
                    currentMusicModel.songArray=musicModel.songArray;
                    
                    if (musicModel.songArray.count>0) {
                        
                        //0.播放音乐
                        [audioManager.musicPlayer clearQueue];
                        [audioManager.musicPlayer pause];
                        rotateState=RotateStateStop;
                        audioManager.musicArray=musicModel.songArray;
                        [audioManager play];
                        
                        //1.添加RightBarButtonItem
                        [self buildBarButtonItem];
                    }else{
                       
                    }
                    
                } andFialure:^(NSError *error) {
                }];
                
            }else if(functionModel.type==FunctionTypeDianPing){   //大众点评
                
                [DianPingTools requestDianpingBy:functionModel.dianPingModel andPage:1 success:^(NSArray *businessArray) {
                    functionModel.dianPingModel.businessArray=businessArray;
                    
                    [_dataArray addObject:functionModel];
                    [_mainTableView reloadData];
                    //滚动到底部
                    NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection:_dataArray.count-1];
                    [_mainTableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                } andFailure:^(NSError *error) {
                     NSLog(@"%@",error);
                }];
                return;

            }else if (functionModel.type==FunctionTypeTelephone){  //打电话
                NSLog(@"%@",functionModel.telephoneModel.name);
                
                NSString *personName=functionModel.telephoneModel.name;
                
                if(personName.length>0){
                    //获得电话
                    [AddressBookTool getPhonesByName:personName Success:^(NSArray *contacts) {
                        //返回结果不为空
                        if (contacts.count>0) {
                            //默认选择第一个匹配的人名 。。。。
                            NSDictionary *person=contacts.firstObject;
                            //获得其电话数组
                            NSArray *phones=person[personName];
                            if (phones.count>0) {
                                //默认打第一个人的第一个电话
                                NSString *phoneNumber = [@"tel://" stringByAppendingString:phones.firstObject];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                            }
                            
                        }
                    } andFailure:^(NSError *error) {
                    
                    }];
                
                }
            
            }
            
        }
        [_dataArray addObject:model];
        [_mainTableView reloadData];
        //滚动到底部
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: 0 inSection: _dataArray.count-1];
        [_mainTableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        
    }
    
    
}





#pragma mark - 功能卡片代理

#pragma mark 点击地图片地图按钮
-(void)cardClickMapBtn:(id)sender andFrom:(NSString *)startPlace toPlace:(NSString *)endPlace{
    if(startPlace.length<=0){
        startPlace=@"当前位置";
    }
    if(endPlace.length<=0){
        endPlace=@"当前位置";
    }
    
    MapMainController *mapController=[[MapMainController alloc] initWithStartPlace:startPlace endPlace:endPlace];
    [self.navigationController pushViewController:mapController animated:YES];


}
#pragma mark 滑动删除卡片
-(void)slideToDeleteCell:(FunctionCell *)slideDeleteCell{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:slideDeleteCell];
    [_dataArray removeObjectAtIndex:indexPath.section];
//    [_mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
}
#pragma mark 点击大众点评
-(void)tapDianPingView:(Business *)business{
    BusinessDetailController *deatilWebView=[[BusinessDetailController alloc] init];
    deatilWebView.businessUrl=business.business_url;
    //跳转到详细页面
    [self.navigationController pushViewController:deatilWebView animated:YES];
}
#pragma mark 点击更多按钮
-(void)clickDianPingMoreBtn:(FunctionModel *)functionModel{
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DianPingListController *dianpingList =   [mainStoryBoard instantiateViewControllerWithIdentifier:@"DianPingListController"];
    
    dianpingList.businessArray=functionModel.dianPingModel.businessArray;
    //跳转更多
    [self.navigationController pushViewController:dianpingList animated:YES];
}


#pragma mark - MusicPlayer Delegate
-(void)musicPlayer:(STKAudioPlayer *)audioPlayer playNextSong:(Song *)song{
    _currentSong=song;

    [rotateImageView sd_setImageWithURL:[NSURL URLWithString:song.cover] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
}
-(void)musicPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    if (state==STKAudioPlayerStateStopped) {
        [self stopRotateAnimate];
    }else if (state==STKAudioPlayerStatePlaying){
        [self rotateImageViewAnimate];
    }
    
}
@end













