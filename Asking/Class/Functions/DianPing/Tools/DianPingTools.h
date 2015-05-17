//
//  DianPingTools.h
//  DianPingDemo
//
//  Created by Lves Li on 15/3/3.
//  Copyright (c) 2015年 Lves. All rights reserved.
// 获取点评信息

#import <Foundation/Foundation.h>
#import "NSString+Contain.h"


@class DianPingModel;
@interface DianPingTools : NSObject

typedef void(^DianPingSuccessBlock)(NSArray * businessArray);
typedef void(^DianPingFailureBlock)(NSError *error);



//请求点评数据
+(void)requestDianpingBy:(DianPingModel *)dianPingModel andPage:(int)page success:(DianPingSuccessBlock)successBlock andFailure:(DianPingFailureBlock)failureBlock;
///获得点评类型
+ (NSString *)getCategory:(NSString *)name;
@end
