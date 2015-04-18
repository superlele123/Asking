//
//  MusicPlayerManager.m
//  Asking
//
//  Created by Lves Li on 15/3/1.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "MusicPlayerManager.h"

@interface MusicPlayerManager ()<STKAudioPlayerDelegate>
{
    NSUInteger _currentIndex;
    STKAudioPlayerState _playerState;
    
}
@end

@implementation MusicPlayerManager
@synthesize musicPlayer=_musicPlayer;
@synthesize musicArray=_musicArray;

+ (MusicPlayerManager *)sharedManager
{
    static MusicPlayerManager *sharedMusicPlayerManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedMusicPlayerManager = [[self alloc] init];
    });
    return sharedMusicPlayerManager;
}

-(instancetype)init{
    if (self=[super init]) {
        _musicPlayer=[[STKAudioPlayer alloc] init];
        _musicPlayer.delegate=self;
    }
    return self;
}

#pragma mark - player delegate
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    
    NSString *songUrl=(NSString *)queueItemId;
    for (NSUInteger i=0;i<_musicArray.count;i++) {
        Song *song=_musicArray[i];
        if ([song.songUrl isEqualToString:songUrl]) {
            _currentIndex=i;
            _currentSong=song;
            //通知代理
            if(self.delegate&&[self.delegate respondsToSelector:@selector(musicPlayer:playNextSong:)]){
                [self.delegate musicPlayer:musicPlayer playNextSong:song];
            }
            break;
        }
    }
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    _playerState=state;
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(musicPlayer:stateChanged:previousState:)]) {
        [self.delegate musicPlayer:audioPlayer stateChanged:state previousState:previousState];
    }
    
}
#pragma mark 播放完毕
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    
    if (stopReason==STKAudioPlayerStopReasonEof) {  //一首完毕
        //播放下一首
        [self playNextSong];
    }
}
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems{
   
}

#pragma mark 播放下一首
- (void)playNextSong {
    if(_musicArray.count<=0){
        return;
    }
    
    NSInteger nextIndex;
    if (_currentIndex+1<=_musicArray.count-1) { //有下一首
        nextIndex=_currentIndex+1;
    }else{
        nextIndex=0;
        _currentIndex=0;
    }
    
    Song *nextSong=_musicArray[nextIndex];
    NSURL *nextUrl=[NSURL URLWithString:nextSong.songUrl];
    [_musicPlayer setDataSource:[STKAudioPlayer dataSourceFromURL:nextUrl] withQueueItemId:nextSong.songUrl];
    //通知代理
    if(self.delegate&&[self.delegate respondsToSelector:@selector(musicPlayer:playNextSong:)]){
        [self.delegate musicPlayer:musicPlayer playNextSong:nextSong];
    }

    
    
    
}
#pragma mark 播放前一首
-(void)playpreviousSong{
    if (_musicArray.count<=0) {
        return;
    }
    
    NSInteger nextIndex;
    if (_currentIndex>=1) {
        nextIndex=_currentIndex-1;
    }else{
        if (_musicArray.count>=2) {
            _currentIndex=_musicArray.count-1;
        }else{
            _currentIndex=0;
        }
        nextIndex=_currentIndex;
        
    }
    
    Song *previousSong=_musicArray[nextIndex];
    NSURL *nextUrl=[NSURL URLWithString:previousSong.songUrl];
    [_musicPlayer setDataSource:[STKAudioPlayer dataSourceFromURL:nextUrl] withQueueItemId:previousSong.songUrl];
    //通知代理
    if(self.delegate&&[self.delegate respondsToSelector:@selector(musicPlayer:playNextSong:)]){
        [self.delegate musicPlayer:musicPlayer playNextSong:previousSong];
    }

}
#pragma mark 播放
-(void)play{
    if (_playerState==STKAudioPlayerStatePlaying) {
        [_musicPlayer pause];
    }else if(_playerState==STKAudioPlayerStatePaused){
        [_musicPlayer resume];
    }else{
        if (_musicArray.count>0) {
            Song *song=_musicArray[_currentIndex];
            NSURL *songUrl=[NSURL URLWithString:song.songUrl];
            [_musicPlayer setDataSource:[STKAudioPlayer dataSourceFromURL:songUrl] withQueueItemId:song.songUrl];
            
            //通知代理
            if(self.delegate&&[self.delegate respondsToSelector:@selector(musicPlayer:playNextSong:)]){
                [self.delegate musicPlayer:musicPlayer playNextSong:song];
            }
        }
        
    }

}
-(void)pause{
    [_musicPlayer pause];
}

-(void)resume{
    [_musicPlayer resume];
}
-(void)stop{
    [_musicPlayer stop];
}



@end
