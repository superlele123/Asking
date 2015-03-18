//
//  BusListController.h
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
// 公交路线列表

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@protocol BusListControllerDelegate <NSObject>

-(void)busListControllerClickedCell:(NSUInteger)index;

@end

@interface BusListController : UITableViewController
///公交方案数组
@property (nonatomic,copy) NSArray *transitArray;
///开始位置
@property (nonatomic,copy) NSString *startPlaceStr;
///结束位置
@property (nonatomic,copy) NSString *endPlaceStr;

///代理
@property (nonatomic,weak)id <BusListControllerDelegate>delegate;

@end
