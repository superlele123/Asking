//
//  News.h
//  NewsDemo
//
//  Created by Lves Li on 15/3/19.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  新闻详情

#import <Foundation/Foundation.h>



typedef enum {
    ///默认值
    NewsCategory_Default,
    ///新闻要闻
    NewsCategory_Marquee,
    ///国内新闻
    NewsCategory_China,
    ///国际新闻
    NewsCategory_World,
    ///互联网
    NewsCategory_IT ,
    ///奇闻轶事
    NewsCategory_Wonder,
    ///科技
    NewsCategory_Tech,
    ///军事
    NewsCategory_Military,
    ///体育
    NewsCategory_Sports
}NewsCategory;



@interface News : NSObject
///标题
@property (nonatomic,copy)NSString *title;
///连接
@property (nonatomic,copy)NSString *link;
///发布者
@property (nonatomic,copy)NSString *author;
///来源
@property (nonatomic,copy)NSString *guid;
///分类
@property (nonatomic,copy)NSString *category;
///发布时间
@property (nonatomic,copy)NSString *pubDate;
///新闻摘要
@property (nonatomic,copy)NSString *summary;



@end
