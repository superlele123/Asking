//
//  Song.h
//  MusicDemo
//
//  Created by Lves Li on 15/2/4.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  歌曲

#import <Foundation/Foundation.h>

@interface Song : NSObject
///歌曲名
@property (nonatomic,copy) NSString *songName;
///音乐家
@property (nonatomic,copy) NSString *artist;
///网络路径
@property (nonatomic,copy) NSString *songUrl;
///本地路径
@property (nonatomic,copy) NSString *localPath;
///封面
@property (nonatomic,copy) NSString *cover;


@end
