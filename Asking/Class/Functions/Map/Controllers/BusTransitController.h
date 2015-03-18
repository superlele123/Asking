//
//  BusTransitController.h
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  公交路线规划详情

#import <UIKit/UIKit.h>


@class AMapTransit;

@interface BusTransitController : UIViewController
///公交方案

@property (nonatomic,strong) AMapTransit *busTransit;

/*
设置起点和终点
*/
-(void)setStartPlace:(NSString *)start andEndPlace:(NSString *)endPlace;

@end
