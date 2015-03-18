//
//  MusicModel.h
//  Asking
//
//  Created by Lves Li on 15/2/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  FunctionModel 的一种MusicModel

#import <Foundation/Foundation.h>

#import "Song.h"

@interface MusicModel : NSObject
///语义
@property (nonatomic,copy) NSString *text;
///搜索歌手名
@property (nonatomic,copy) NSString *artist;
///歌曲名
@property (nonatomic,copy) NSString *songName;
///音乐数组，存放Music
@property (nonatomic,strong) NSArray *songArray;

@end
