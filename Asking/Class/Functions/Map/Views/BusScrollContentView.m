//
//  BusScrollContentView.m
//  高德地图
//
//  Created by Lves Li on 14/12/28.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "BusScrollContentView.h"
#import "TimeSecondsToString.h"


#define kPadding 10.f
#define kMargging 5.f




@interface BusScrollContentView ()
{
    
    ///下一个按钮提示
    UIImageView *arrowView;
    
}

@end

@implementation BusScrollContentView
@synthesize contentWebView;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        CGSize viewSize=frame.size;
        //添加公交方案View
        contentWebView=[[UIWebView alloc] initWithFrame:CGRectMake(kPadding, kPadding-3.f,viewSize.width*0.85 ,viewSize.height-kPadding*2 )];
        contentWebView.backgroundColor=[UIColor clearColor];
        [self addSubview:contentWebView];
        contentWebView.scrollView.scrollEnabled=NO;
        contentWebView.userInteractionEnabled=YES;
        self.userInteractionEnabled=YES;
        
        self.hasNext=YES;
        
        //添加下一个按钮
        arrowView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        arrowView.bounds=CGRectMake(0, 0, 10, 25);
        arrowView.center=CGPointMake(viewSize.width-10.f, viewSize.height/2.f);
        [self addSubview:arrowView];
        
        
    }
    return self;
}

/*
设置交通方案
*/
-(void)setTransit:(AMapTransit *)transit{
    
    NSMutableString *title=[NSMutableString string];
    NSString *detailTitle=[NSString stringWithFormat:@"花费%@ | 步行%ld米",[TimeSecondsToString secondsToString:transit.duration],(long)transit.walkingDistance];
    for (AMapSegment *segment in transit.segments ) {
        if (segment.busline.name) {
            NSString *busLineName=segment.busline.name;
            NSUInteger loc=[busLineName rangeOfString:@"("].location;
            if (loc>0) {  //有（）
                busLineName=[busLineName substringToIndex:loc];
            }
            
            [title appendFormat:@"%@→",busLineName];
        }
        
    }
    
    
    //去除末尾的箭头
    if ([title hasSuffix:@"→"]) {
        [title replaceCharactersInRange:NSMakeRange(title.length-1, 1) withString:@""];
    }
    //第一行css修饰，字体一行显示，多余的省略；第二行字体减小一个单位，颜色为灰色
    
    NSString *str=[NSString stringWithFormat:@"<font style=\"text-overflow:ellipsis; white-space:nowrap; overflow:hidden;line-height:25px;\">%@</font></br><font size=-1 color=gray>%@</font>",title,detailTitle];
    
    [contentWebView loadHTMLString:str baseURL:nil];

}

-(void)setHasNext:(BOOL)hasNext{
    if (hasNext==NO) {
        arrowView.hidden=YES;
        
    }
}



@end








