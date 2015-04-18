//
//  MusicController.m
//  Asking
//
//  Created by Lves Li on 15/2/28.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "MusicController.h"
#import "MusicTools.h"
#import "STKDataSource.h"
#import "MusicPlayerManager.h"

#import "ColorTool.h"
#import "MBProgressHUD.h"
#import "UIImage+AverageColor.h"
#import "UIColor+Inverse.h"




@interface MusicController ()<UIGestureRecognizerDelegate,MusicPlayerDelegate,UITextFieldDelegate>
{
    MusicPlayerManager *_audioPlayerManager;
    
    NSUInteger _currentIndex;
    ///初始触摸点
    CGPoint originaPoint;
    //定时器
    NSTimer *_songTimer;
    
    //背景图片
    UIImageView *_backImageView;
    
    //输入框页面
    UIView *_searchSongView;
    
    
}


@end

@implementation MusicController
@synthesize currentSong=_currentSong;

#pragma mark - 生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图片
    _backImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    _backImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_backImageView atIndex:0];
    //添加毛玻璃效果
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEfView.frame = self.view.bounds;
    visualEfView.alpha = 0.98f;
    [_backImageView addSubview:visualEfView];
    
   
    
    self.view.backgroundColor=[UIColor clearColor];
    
    //设置放器前置图片
    [self addPlayImage];
    //添加手势
    [self addGestureRecognizer];
    //设置可以后台播放
    [self setBackGroundPlay];
    
    //添加摇一摇
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置播放器数据源
    [self setMusicPlayer];
    
    [self changUIParam:_currentSong];
    //创建定时器
    if(_songTimer==nil){
        _songTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_songTimer forMode:NSRunLoopCommonModes];
        
    }
    
    //更新播放按钮图片
    [self updatePlayButtonImage:_audioPlayerManager.musicPlayer.state];
    //判断当前状态
    if (_audioPlayerManager.musicPlayer.state==STKAudioPlayerStatePlaying||_audioPlayerManager.musicPlayer.state==STKAudioPlayerStateRunning) {
        [_songTimer fire];
    }else{
        if (_songTimer.isValid) {
            [_songTimer invalidate];
            _songTimer = nil;
        }
    }
    
    
    [self becomeFirstResponder];
    //注册后台控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if (_songTimer.isValid) {
        [_songTimer invalidate];
        _songTimer = nil;
    }
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [super viewWillDisappear:animated];
   
}

#pragma 点击返回
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 添加手势
-(void)addGestureRecognizer{
    //添加左右滑动手势
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - set MusicPlayer Datasource
-(void)setMusicPlayer{
    
    _audioPlayerManager = [MusicPlayerManager sharedManager];
    _audioPlayerManager.delegate=self;
}

#pragma mark - 手势代理函数
#pragma 左右滑动手势处理
-(void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint panPoint=[panGestureRecognizer locationInView:self.view];
    if (panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        originaPoint=panPoint;
    }else if (panGestureRecognizer.state==UIGestureRecognizerStateEnded){
        CGPoint endPoint=panPoint;
        if (endPoint.x-originaPoint.x>60) {                             //向右滑
            //播放下一首
            [_audioPlayerManager playNextSong];
        }
        
        if (endPoint.x-originaPoint.x<-60){                             //向左滑
            //播放前一首
             [_audioPlayerManager playpreviousSong];
        }
        
        if (endPoint.y-originaPoint.y>100.f) {                          //向下滑
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        
    }
    
}
#pragma mark 单击手势处理
-(void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (tapGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        [_audioPlayerManager play];
    }
    
}


#pragma mark 添加播放器前置图片
-(void)addPlayImage{
   
   
    //歌曲图片
    _imageView.layer.masksToBounds=YES;
    _imageView.layer.cornerRadius=self.imageView.frame.size.width/2.f;
    
   
    
    
//    //前置图片
//    CGFloat imageViewX=[UIScreen mainScreen].bounds.size.width/2.f;
//    UIImageView *playerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 255, 255)];
//    playerImageView.image=[UIImage imageNamed:@"player_playimage"];
//    CGPoint center=CGPointMake(imageViewX, _imageView.center.y);
//    playerImageView.center=center;
//    [self.view addSubview:playerImageView];
    
}




#pragma mark 播放
- (IBAction)playBtnClick:(id)sender {
    [_audioPlayerManager play];
   
}
#pragma mark 闹钟
- (IBAction)clockBtnClick:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"添加闹钟";
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        
    }];

}

#pragma mark 收藏
- (IBAction)likeBtnClick:(id)sender {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"收藏成功";
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        
    }];
    
}

#pragma mark 改变UI
-(void)changUIParam:(Song *)song{
    //背景图片
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:song.cover] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    //歌曲封面
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:song.cover] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    //设置歌曲名
    self.songNameLabel.text=song.songName;
    
    self.artistLabel.text=[NSString stringWithFormat:@"一 %@ 一",song.artist];
    //设置背景颜色
//    self.view.backgroundColor=[ColorTool colorFromImageUrl:song.cover];
  
//    //设置字体颜色
//    self.songNameLabel.textColor=[self.view.backgroundColor inverseColor];
//    self.timerLabel.textColor=self.songNameLabel.textColor;
//    self.artistLabel.textColor=self.songNameLabel.textColor;
    
   
    
}
#pragma  mark - 设置后台播放
#pragma  mark 设置后台播放属性
-(void)setBackPlayParames:(Song *)song{
    
    //设置锁屏后的图片
    UIImage *lockImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:song.cover]]];
    
    MPMediaItemArtwork  *artwork=[[MPMediaItemArtwork alloc] initWithImage:lockImage];
    NSDictionary *mediaDict=@{
                              MPMediaItemPropertyTitle:song.songName,
                              MPMediaItemPropertyMediaType:@(MPMediaTypeAnyAudio),
                              MPMediaItemPropertyPlaybackDuration:@(_audioPlayerManager.musicPlayer.duration),
                              MPNowPlayingInfoPropertyPlaybackRate:@1.0,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime:@(_audioPlayerManager.musicPlayer.progress),
                              MPMediaItemPropertyAlbumArtist:song.artist,
                              MPMediaItemPropertyArtist:song.artist,
                              MPMediaItemPropertyArtwork:artwork};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaDict];
   
}
#pragma mark  音乐远程控制
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [_audioPlayerManager play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_audioPlayerManager playpreviousSong];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [_audioPlayerManager playNextSong];
                break;
            case UIEventSubtypeRemoteControlPause:
                [_audioPlayerManager pause];
                
                break;
            case UIEventSubtypeRemoteControlPlay :
                [_audioPlayerManager play];
                break;
            default:
                break;
        }
    }
}
#pragma mark 设置可以后台播放
-(void)setBackGroundPlay{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    NSError *activeError=nil;
    if (![session setActive:YES error:&activeError]) {
        NSLog(@"设置激活音乐Session失败。");
    }
    NSError *categoryError=nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&categoryError]) {
        NSLog(@"设置音频播放类型失败。");
    }
}




#pragma mark 改变进度
-(void)updateProgress{
    self.timerLabel.text=[NSString stringWithFormat:@"%@/%@",[self getTimeFormat:_audioPlayerManager.musicPlayer.progress],[self getTimeFormat:_audioPlayerManager.musicPlayer.duration]];
    
     Song *song=_audioPlayerManager.currentSong;
     //更改后台播放属性
     [self setBackPlayParames:song];
    
    
}


#pragma mark - player delegate

/// Raised when the state of the player has changed
-(void) musicPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    [self updatePlayButtonImage:state];
    if (state==STKAudioPlayerStatePlaying) {
        if(_songTimer==nil){
            _songTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_songTimer forMode:NSRunLoopCommonModes];
            [_songTimer fire];
        }
        
    }
    
    
    
}

-(void)musicPlayer:(STKAudioPlayer *)audioPlayer playNextSong:(Song *)song{
    [self changUIParam:song];
}

#pragma mark 修改播放键图片
-(void)updatePlayButtonImage:(STKAudioPlayerState)state{
    if (state==STKAudioPlayerStatePlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
    }else if (state==STKAudioPlayerStatePaused){
        [self.playButton setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
        if (_songTimer.isValid) {
            [_songTimer invalidate];
            _songTimer = nil;
        }
    }

}


#pragma mark - 获得时间固定格式
-(NSString *)getTimeFormat:(double)time{
    //分钟
    int minute=time/60;
    int second=(int)time%60;
    
    NSString *minuteStr=[NSString stringWithFormat:@"%d",minute];
    if (minuteStr.length==1) {
        minuteStr=[NSString stringWithFormat:@"0%@",minuteStr];
    }
    NSString *secondStr=[NSString stringWithFormat:@"%d",second];
    if (secondStr.length==1) {
        secondStr=[NSString stringWithFormat:@"0%@",secondStr];
    }
    
    NSString *timeFormatStr=[NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    return timeFormatStr;
}

#pragma mark - 摇一摇代理
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (_searchSongView==nil) {
         _searchSongView=[self searchView];
    }
    
    [self.view addSubview:_searchSongView];
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}

#pragma mark searchView
-(UIView *)searchView{
    
    UIView *searchView=[[UIView alloc] initWithFrame:self.view.bounds];
    
    //添加毛玻璃效果
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEfView.frame = self.view.bounds;
    visualEfView.alpha = 0.85f;
    [searchView addSubview:visualEfView];
    //添加搜索框
    UITextField *searchField=[self searchTextField];
    [searchView addSubview:searchField];
   
    //添加手势识别
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchOk:)];
    [searchView addGestureRecognizer:tapGestureRecognizer];

    return searchView;
}


#pragma mark textField

-(UITextField *)searchTextField{

    //搜索框
    UITextField *searchField=[[UITextField alloc] init];
    searchField.bounds=CGRectMake(0, 0, kScreenWidth-50, 40);
    searchField.center=CGPointMake(self.view.center.x, 200);
    searchField.placeholder=@"你想听的歌手名或者歌曲名";
    searchField.backgroundColor=[UIColor whiteColor];
    searchField.layer.masksToBounds=YES;
    searchField.layer.cornerRadius=20.f;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;  //清楚按钮
    searchField.returnKeyType =UIReturnKeySearch;  //键盘回车键类型
    searchField.delegate=self;
    searchField.clearsOnBeginEditing = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    searchField.leftView = paddingView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    return searchField;

}
#pragma mark TextFild 代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [_searchSongView removeFromSuperview];
    
    //搜索歌曲
    NSString *searchKey=textField.text;
    if (searchKey.length>0) {
        textField.text=@"";
        [self searchSong:searchKey];
    }
    return YES;
}




#pragma mark 点击搜索页面 去除searchview
-(void)searchOk:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (tapGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        [_searchSongView removeFromSuperview];
    }

}
#pragma mark 搜索
-(void)searchSong:(NSString *)key{

    [MusicTools getMusicByArtist:key andSong:@"" andSuccess:^(MusicModel *musicModel) {
        
        if (musicModel.songArray.count>0) {
//            [_audioPlayerManager.musicPlayer clearQueue];
             _audioPlayerManager.musicArray=musicModel.songArray;
           
            [_audioPlayerManager playNextSong];
        }else{
            [self searchTip];
        }
    } andFialure:^(NSError *error) {
        [self searchTip];
    }];

}

#pragma mark 为搜索到提示
-(void)searchTip{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"未搜索到！";
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        
    }];


}



@end
