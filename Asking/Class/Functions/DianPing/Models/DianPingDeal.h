//
//  DianPingDeal.h
//  DianPingDemo
//
//  Created by Lves Li on 15/3/4.
//  Copyright (c) 2015年 Lves. All rights reserved.
// 点评商家团购

#import <Foundation/Foundation.h>

@interface DianPingDeal : NSObject
///团购ID
@property (nonatomic,copy) NSString *dealID;
///团购描述
@property (nonatomic,copy) NSString *dealDescription;
///团购页面链接
@property (nonatomic,copy) NSString *dealUrl;


-(id)initWithDic:(NSDictionary *)dic;

@end
