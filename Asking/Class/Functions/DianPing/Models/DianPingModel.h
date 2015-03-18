//
//  DianPingModel.h
//  Asking
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DianPingModel : NSObject
///城市名
@property (nonatomic,copy)NSString *cityName;
///分类
@property (nonatomic,copy)NSString *category;
///城区，行政区
@property (nonatomic,copy)NSString *district;
///经纬度
@property (nonatomic,assign)CLLocationCoordinate2D coordinate2D;

///商铺数组
@property (nonatomic,strong) NSArray *businessArray;

@end
