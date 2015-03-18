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

#import "UIImage+AverageColor.h"
#import "UIColor+Inverse.h"
@interface MusicController ()<UIGestureRecognizerDelegate,MusicPlayerDelegate>
{
    MusicPlayerManager *_audioPlayerManager;
    
    NSUInteger _currentIndex;
    ///初始触摸点
    CGPoint originaPoint;
    
    NSTimer *_songTimer;
    
}


@end

@implementation MusicController
@synthesize currentSong=_currentSong;

#pragma mark - 生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //设置放器前置图片
    [self addPlayImage];
    //添加手势
    [self addGestureRecognizer];
    //设置播放器数据源
    [self setMusicPlayer];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changUIParam:_currentSong];
    //创建定时器
    if(_songTimer==nil){
        _songTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_songTimer forMode:NSDefaultRunLoopMode];
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
            [self nextBtnClick:nil];
        }
        
        if (endPoint.x-originaPoint.x<-60){                             //向左滑
            //播放前一首
            [self previousBtnClick:nil];
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
    _imageView.layer.cornerRadius=_imageView.frame.size.width/2.f;
    //前置图片
    CGFloat imageViewX=[UIScreen mainScreen].bounds.size.width/2.f;
    UIImageView *playerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 255, 255)];
    playerImageView.image=[UIImage imageNamed:@"player_playimage"];
    CGPoint center=CGPointMake(imageViewX, _imageView.center.y);
    playerImageView.center=center;
    [self.view addSubview:playerImageView];
    
}




#pragma mark 播放
- (IBAction)playBtnClick:(id)sender {
    [_audioPlayerManager play];
   
}
#pragma mark 上一首
- (IBAction)previousBtnClick:(id)sender {
    [_audioPlayerManager playpreviousSong];
}

#pragma mark 下一首
- (IBAction)nextBtnClick:(id)sender {
    [_audioPlayerManager playNextSong];
}

#pragma mark 改变UI
-(void)changUIParam:(Song *)song{
    
    //歌曲封面
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:song.cover] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    //设置歌曲名
    self.songNameLabel.text=song.songName;
    
    self.artistLabel.text=[NSString stringWithFormat:@"一 %@ 一",song.artist];
    //设置背景颜色
    self.view.backgroundColor=[ColorTool colorFromImageUrl:song.cover];
    //设置字体颜色
    self.songNameLabel.textColor=[self.view.backgroundColor inverseColor];
    self.timerLabel.textColor=self.songNameLabel.textColor;
    self.artistLabel.textColor=self.songNameLabel.textColor;
    
}
#pragma mark 改变进度
-(void)updateProgress{
    self.timerLabel.text=[NSString stringWithFormat:@"%@/%@",[self getTimeFormat:_audioPlayerManager.musicPlayer.progress],[self getTimeFormat:_audioPlayerManager.musicPlayer.duration]];
}


#pragma mark - player delegate

/// Raised when the state of the player has changed
-(void) musicPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    [self updatePlayButtonImage:state];
    if (state==STKAudioPlayerStatePlaying) {
        if(_songTimer==nil){
            _songTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_songTimer forMode:NSRunLoopCommonModes];
//            [[NSRunLoop currentRunLoop] addTimer:_songTimer forMode:NSDefaultRunLoopMode];
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


@end
