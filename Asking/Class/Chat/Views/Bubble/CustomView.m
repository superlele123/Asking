//
//  CustomView.m
//  LvesMessageShow
//
//  Created by Lves Li on 14/11/11.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    if (frame.size.width<50) {
        frame.size.width=50.f;
    }
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
    }
    
    return self;
}



- (void)drawRect:(CGRect)rect {
    CGSize size=rect.size;
    CGFloat width=size.width;
    CGFloat height=size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *bgcolor=[UIColor whiteColor];
    
    CGContextSetFillColorWithColor(context,bgcolor.CGColor); //设置填充颜色
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 11);
    CGContextAddCurveToPoint(context,5,12.5,10,15,10,10);
    CGContextAddCurveToPoint(context, 10, 1, 20, 1, 20, 1);
    CGContextAddCurveToPoint(context, 20, 1, height, 1, width-10, 1);
    CGContextAddCurveToPoint(context, width-10, 1,width , 1, width-1, 15);
    CGContextAddCurveToPoint(context, width-1, 30, width-1, height-10, width-1, height-10);
    CGContextAddCurveToPoint(context, width-1, height-5, width-5, height-1, width-10, height-1);
    CGContextAddCurveToPoint(context, width-10, height-1, width-50, height-1, 20, height-1);
    CGContextAddCurveToPoint(context, 15, height-1, 10, height-5, 10, height-10);
    CGContextAddCurveToPoint(context, 10, height-10, 10, 30, 10, 20);
    CGContextAddCurveToPoint(context, 10, 20, 3, 20, 0, 10);
    
    CGContextFillPath(context); //填充
    //CGContextStrokePath(context);
}


@end
