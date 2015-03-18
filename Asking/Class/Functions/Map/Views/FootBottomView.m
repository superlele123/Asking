//
//  FootBottomView.m
//  高德地图
//
//  Created by Lves Li on 14/12/24.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "FootBottomView.h"
#import "TimeSecondsToString.h"

#define  kPadding 10.f
#define  kPaddingH 5.f
#define  kLabelScale 0.8f


#define  kButtonTextBlueColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"file_tital_bj"]]
#define  kLineBackColor [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1]


@interface FootBottomView ()
{
   
    UIWebView *webView;
}


@end

@implementation FootBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.99];
        CGSize size=frame.size;
        
        //添加WebView
        CGFloat labelWidth=size.width*kLabelScale;
        
        webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 55)];
        webView.scrollView.scrollEnabled=NO;
        [self addSubview:webView];
        
        //添加详情按钮
        
        UIImageView *detailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(size.width-47/2.f-2*kPadding, kPadding,47/2.f ,69/2.f )];
        [detailImageView setImage:[UIImage imageNamed:@"poi_card_detail_icon"]];
        [self addSubview:detailImageView];
        
       
        //添加单击事件
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail:)];

        [self addGestureRecognizer:tapGesture];
        
        
    }
    return self;
}
/*
 设置内容
 
*/
-(void)setBottomViewDistance:(NSInteger)distance andDuration:(NSInteger)duration andTaxiCost:(CGFloat)taxiCost{

    //标题
    NSString *title=[NSString stringWithFormat:@"%.2f公里 | %@",distance/1000.f,[TimeSecondsToString secondsToString:duration]];
    //子标题
    NSString *taxiCostStr;
    if (taxiCost!=0) {
        taxiCostStr=[NSString stringWithFormat:@"<font size=-1 color=gray>打车约<font color=red>%.2f</font>元</font>",taxiCost];
    }

    
    
    NSString *str;
    if (taxiCostStr.length>0) {   //有打车费用，两行显示
        str=[NSString stringWithFormat:@"<font style=\"line-height:25px \">%@</font></br>%@",title,taxiCostStr];
    }else{                        //没有打车费用
        title=[NSString stringWithFormat:@"<font style=\"line-height:25px \">大约%.2f公里</font></br><font size=-1 color=gray>需花费<font color=red>%@</font></font>",distance/1000.f,[TimeSecondsToString secondsToString:duration]];;
        
        str=[NSString stringWithFormat:@"<p style=\"margin-top:5px;\">%@</p>",title];
    }
    
    
    [webView loadHTMLString:str baseURL:nil];
    
}
/*
单击视图查看详情
*/

-(void)tapDetail:(id)sender{
    //通知代理点击详情按钮
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tapDetailView)]) {
        [self.delegate tapDetailView];
    }
    
}


@end
