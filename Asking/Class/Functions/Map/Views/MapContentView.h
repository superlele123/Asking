//
//  MapContentView.h
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  主视图中得卡片

#import "CellContentBaseView.h"




@interface MapContentView : CellContentBaseView


///打车按钮
@property (nonatomic,readonly) UIButton *taxiBtn;
///地图按钮
@property (nonatomic,readonly) UIButton *mapBtn;
///开始点
@property (nonatomic,copy)NSString *startPlace;
///结束点
@property (nonatomic,copy)NSString *endPlace;


@end
