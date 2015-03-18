//
//  BusTransitCell.h
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  公交路线详情Cell

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@protocol BusTransitCellDelegate <NSObject>
@end




@interface BusTransitCell : UITableViewCell
///详情按钮
//@property (nonatomic,readonly) UIButton *moreBtn;


/*
设置公交路段和路段下标
*/
-(void)setSegment:(AMapSegment *)segment andIndex:(NSInteger)index andIsEnd:(BOOL)isEnd andIfShowMore:(BOOL)ifShowMore;

/*
计算cell的高度
*/
+(CGFloat)heightOfTransitCellWithSegment:(AMapSegment *)segment andIfShowMore:(BOOL)ifShowMore;
@end
