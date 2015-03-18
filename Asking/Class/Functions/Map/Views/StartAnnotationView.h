//
//  StartAnnotationView.h
//  flowofficial
//
//  Created by Lves Li on 14-8-27.
//  Copyright  (c) 2014年 Jesse Cheng. All rights reserved.
//  开始大头针上边的View

#import <MAMapKit/MAMapKit.h>
@interface StartAnnotationView : MAAnnotationView
///Title  
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;
///开始按钮
@property (nonatomic, readonly) UIButton *startButton;
/*
 设置按钮标题
*/
-(void)setBtnTitile:(NSString *)titile;
@end
