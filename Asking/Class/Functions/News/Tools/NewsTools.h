//
//  NewsTools.h
//  NewsDemo
//
//  Created by Lves Li on 15/3/6.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  新闻接口

#import <Foundation/Foundation.h>
#import "News.h"

typedef void(^NewsSuccessBlock)(NSArray *newsArray);
typedef void(^NewsFailureBlock)(NSError *error);


#define kNewsTitle @"title"
#define kNewsLink @"link"
#define kNewsAuthor @"author"
#define kNewsGuid @"guid"
#define kNewsCategory @"category"
#define kNewsPubDate @"pubDate"
#define kNewsDescription @"description"

@interface NewsTools : NSObject



/*
获得新闻
*/
+(void)requestByCategory:(NSString *)newsCategory newsSuccess:(NewsSuccessBlock)success andFailure:(NewsFailureBlock)failure;
@end
