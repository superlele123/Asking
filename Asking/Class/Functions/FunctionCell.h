//
//  FunctionCell.h
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  功能Cell

#import <UIKit/UIKit.h>
#import "CellContentBaseView.h"
#import "Business.h"
@class FunctionCell;
@protocol FunctionCellCardDelegate <NSObject>
@optional
/*
点击地图卡片
*/
-(void)cardClickMapBtn:(id)sender andFrom:(NSString *)startPlace toPlace:(NSString *)endPlace;
/*
滑动删除代理
*/
-(void)slideToDeleteCell:(FunctionCell *)slideDeleteCell;
/*
点击大众点评view
*/
-(void)tapDianPingView:(Business *)business;
/*
点击更多按钮
*/
-(void)clickDianPingMoreBtn:(FunctionModel *)functionModel;

@end








@interface FunctionCell : UITableViewCell
///卡片代理
@property (nonatomic,weak)id <FunctionCellCardDelegate> delegate;

///数据模型
@property (nonatomic,strong) FunctionModel *functionModel;


/*
 获得Cell的高度
 */

+(CGFloat)heightForFunctionCell:(FunctionModel *)model;
@end
