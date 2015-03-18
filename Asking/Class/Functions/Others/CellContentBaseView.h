//
//  CellContentBaseView.h
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  FunctionCell的内容视图

#import <UIKit/UIKit.h>
#import "FunctionModel.h"


#define kFunctionCellBottomLineH  5.f


@protocol FunctionCellProtocol <NSObject>



@end


@interface CellContentBaseView : UIView

/*
 获得view的高度
 */

+(CGFloat)heightForContentView:(FunctionModel *)model;

/*
 设置数据源
 */

-(void)setFunctionModel:(FunctionModel *)model;
@end
