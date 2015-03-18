//
//  FootBottomView.h
//  高德地图
//
//  Created by Lves Li on 14/12/24.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  步行底部详情页面

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>
-(void)tapDetailView;

@end


@interface FootBottomView : UIView

///单击详情代理
@property (nonatomic,weak)id<BottomViewDelegate>delegate;

-(void)setBottomViewDistance:(NSInteger)distance andDuration:(NSInteger)duration andTaxiCost:(CGFloat)taxiCost;

@end
