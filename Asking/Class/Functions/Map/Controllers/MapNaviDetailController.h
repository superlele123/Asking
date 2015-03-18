//
//  MapNaviDetailController.h
//  高德地图
//
//  Created by Lves Li on 14/12/29.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  步行或者驾车导航详情页面

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface MapNaviDetailController : UIViewController
///驾车或者步行方案
@property (nonatomic,strong)AMapPath *mapPath;
//公交方案
@property (nonatomic,strong)AMapTransit *mapTransit;


///起始点
@property (nonatomic,copy) NSString *startPlace;
///终点
@property (nonatomic,copy) NSString *endPlace;
@end
