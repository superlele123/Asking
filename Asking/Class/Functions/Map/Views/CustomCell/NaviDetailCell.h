//
//  NaviDetailCell.h
//  高德地图
//
//  Created by Lves Li on 14/12/31.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  规划方案cell

#import <UIKit/UIKit.h>

@interface NaviDetailCell : UITableViewCell
/*
 * 设置Cell的Step指示和方向图片
 *
 */
-(void)setImageViewWithAction:(NSString *)action andSetpInstruction:(NSString *)instruction;

/*
 获得Cell的高度
 */
+(CGFloat)heightOfCellWithStepInstruction:(NSString *)instruction;
@end
