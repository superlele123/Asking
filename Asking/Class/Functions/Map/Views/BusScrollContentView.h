//
//  BusScrollContentView.h
//  高德地图
//
//  Created by Lves Li on 14/12/28.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  公交滚动视图内容视图

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface BusScrollContentView : UIView
///交通方案
@property (nonatomic,strong) AMapTransit *transit;
///是否还有下一个
@property (nonatomic,assign) BOOL hasNext;
///详情视图
@property (nonatomic,readonly)UIWebView *contentWebView;

@end
