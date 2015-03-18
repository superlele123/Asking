//
//  MusicTools.m
//  Asking
//
//  Created by Lves Li on 15/2/3.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "MusicTools.h"
#import "AFNetworking.h"
#import "SBJson.h"






@implementation MusicTools
+(void)getMusicByArtist:(NSString *)artist andSong:(NSString *)song andSuccess:(MusicSuccessBlock)musicSuccess andFialure:(MusicFaildBlock)musicFaild{
    
    NSString *key=@"";
    if (song&&song.length>0) {
         key=[NSString stringWithFormat:@"%@",song];
    }
    if (artist&&artist.length>0) {
        key=[NSString stringWithFormat:@"%@%@",key,artist];
    }
   
    //1. 获得属性
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:key,@"key",@"931cf2d8462054b97a53846cd1a3bd71",@"_xiamitoken" ,nil];
    //2. 请求虾米
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];   //一定要加
    [manager GET:@"http://www.xiami.com/web/search-songs"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             //3.解析结果
             @try {
                 NSString *responsStr=[NSString stringWithUTF8String:[responseObject bytes]];
                 id results=[responsStr JSONValue];
                 //4. 获得数组
                 if ([results isKindOfClass:[NSArray class]]) {
                     
                     MusicModel *musicModel=(MusicModel*)[[MusicModel alloc] init];
                     
                     musicModel.songName=song;
                     musicModel.artist=artist;
                     
                     NSMutableArray *songArray=[NSMutableArray array];
                     for (NSDictionary *oneSongDic in results) {
                         Song *song=[[Song alloc] init];
                         song.artist=oneSongDic[@"author"];
                         song.songName=oneSongDic[@"title"];
                         song.songUrl=oneSongDic[@"src"];
                         song.cover=oneSongDic[@"cover"];
                         [songArray addObject:song];
                     }
                     musicModel.songArray=songArray;
                     
                     //5. 返回结果
                     if(musicSuccess){
                         musicSuccess(musicModel);
                     }
                     
                 }else{  //解析错误
                     if(musicFaild){
                         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"解析错误"                                                                      forKey:NSLocalizedDescriptionKey];
                         musicFaild([NSError errorWithDomain:@"虾米解析错误" code:LvesMusicErrorType_Faild userInfo:userInfo]);
                     }
                 }
                 
             }
             @catch (NSException *exception) {
                 if(musicFaild){
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"解析错误"                                                                      forKey:NSLocalizedDescriptionKey];
                     musicFaild([NSError errorWithDomain:@"虾米解析错误" code:LvesMusicErrorType_Faild userInfo:userInfo]);
                 }
             }
             @finally {
                 
             }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(musicFaild){
            musicFaild(error);
        }
        
    }];

}

+(void)getMusicFromSOSOByArtist:(NSString *)artist andSong:(NSString *)song andSuccess:(MusicSuccessBlock)musicSuccess andFialure:(MusicFaildBlock)musicFaild{
    
    NSString *key=@"";
    if (song&&song.length>0) {
        key=[NSString stringWithFormat:@"%@",song];
    }
    if (artist&&artist.length>0) {
        key=[NSString stringWithFormat:@"%@%@",key,artist];
    }
    
//    NSString *url=[NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@",@"忘情水"];
//    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                                       timeoutInterval:10];
//    
//    [request setHTTPMethod: @"GET"];
//    
//    NSError *requestError;
//    NSURLResponse *urlResponse = nil;
//    
//    
//    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
//    
//    NSString* newStr = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
//  
    
    
    
    //1. 获得属性
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:key,@"s",@"1",@"type",nil];
    //2. 请求虾米
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];   //一定要加
    [manager GET:@"http://music.163.com/#/search/m/"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             //3.解析结果
             @try {
                 NSString *responsStr=[NSString stringWithUTF8String:[responseObject bytes]];
                 id results=[responsStr JSONValue];
                 //4. 获得数组
                 if ([results isKindOfClass:[NSArray class]]) {
                     
                     MusicModel *musicModel=(MusicModel*)[[MusicModel alloc] init];
                     
                     musicModel.songName=song;
                     musicModel.artist=artist;
                     
                     NSMutableArray *songArray=[NSMutableArray array];
                     for (NSDictionary *oneSongDic in results) {
                         Song *song=[[Song alloc] init];
                         song.artist=oneSongDic[@"author"];
                         song.songName=oneSongDic[@"title"];
                         song.songUrl=oneSongDic[@"src"];
                         song.cover=oneSongDic[@"cover"];
                         [songArray addObject:song];
                     }
                     musicModel.songArray=songArray;
                     
                     //5. 返回结果
                     if(musicSuccess){
                         musicSuccess(musicModel);
                     }
                     
                 }else{  //解析错误
                     if(musicFaild){
                         NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"解析错误"                                                                      forKey:NSLocalizedDescriptionKey];
                         musicFaild([NSError errorWithDomain:@"虾米解析错误" code:LvesMusicErrorType_Faild userInfo:userInfo]);
                     }
                 }
                 
             }
             @catch (NSException *exception) {
                 if(musicFaild){
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"解析错误"                                                                      forKey:NSLocalizedDescriptionKey];
                     musicFaild([NSError errorWithDomain:@"虾米解析错误" code:LvesMusicErrorType_Faild userInfo:userInfo]);
                 }
             }
             @finally {
                 
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if(musicFaild){
                 musicFaild(error);
             }
             
         }];
    
}


@end
