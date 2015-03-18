//
//  MusicTools.h
//  Asking
//
//  Created by Lves Li on 15/2/3.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  音乐

#import <Foundation/Foundation.h>
#import "Song.h"
#import "MusicModel.h"


#define CustomErrorDomain @"虾米错误"
typedef enum {
    
    LvesMusicErrorType_NotFound=1,
    LvesMusicErrorType_Faild,
    LvesMusicErrorType_Error,
}LvesMusicErrorType;


typedef void (^MusicSuccessBlock) (MusicModel * musicModel);
typedef void (^MusicFaildBlock)(NSError *error);



@interface MusicTools : NSObject
///虾米请求
+(void)getMusicByArtist:(NSString *)artist andSong:(NSString *)song andSuccess:(MusicSuccessBlock)musicSuccess andFialure:(MusicFaildBlock)musicFaild;


+(void)getMusicFromSOSOByArtist:(NSString *)artist andSong:(NSString *)song andSuccess:(MusicSuccessBlock)musicSuccess andFialure:(MusicFaildBlock)musicFaild;
@end
