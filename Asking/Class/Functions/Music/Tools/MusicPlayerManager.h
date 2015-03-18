//
//  MusicPlayerManager.h
//  Asking
//
//  Created by Lves Li on 15/3/1.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"
#import "MusicTools.h"
#import "STKDataSource.h"



@protocol MusicPlayerDelegate <NSObject>
@optional
-(void)musicPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState;

-(void)musicPlayer:(STKAudioPlayer *)audioPlayer playNextSong:(Song *)song;
@end


@interface MusicPlayerManager : NSObject
{
    STKAudioPlayer *musicPlayer;
    NSArray *musicArray;
}
@property (nonatomic,strong) Song *currentSong;
@property (nonatomic,strong) STKAudioPlayer *musicPlayer;
@property (nonatomic,strong) NSArray *musicArray;

@property (nonatomic,weak) id <MusicPlayerDelegate> delegate;

+ (MusicPlayerManager *)sharedManager;

-(void)play;
-(void)stop;
-(void)pause;
-(void)resume;


-(void)playNextSong;
-(void)playpreviousSong;

@end
