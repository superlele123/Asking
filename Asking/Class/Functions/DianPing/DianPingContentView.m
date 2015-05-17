//
//  DianPingContentView.m
//  Asking
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "DianPingContentView.h"

#import "DianPingModel.h"

#define kDianPinViewH 60.f
#define kMoreButtonH 30.f
#define kTipViewH 45.f

@interface DianPingContentView ()
{
   
}

@end

@implementation DianPingContentView
@synthesize firstDianPingView;
@synthesize secondDianPingView;
@synthesize thirdDianPingView;
@synthesize moreBtn;

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        
        
        CGFloat width= kScreenWidth-kCellMargin*2;
        //1.添加三条大众点评数据
        firstDianPingView=(DianPingView *)[[[NSBundle mainBundle] loadNibNamed:@"DianPingView" owner:self options:nil] firstObject];
        firstDianPingView.tag=1001;
        firstDianPingView.frame=CGRectMake(0, kTipViewH-5.f,width, kDianPinViewH);

        secondDianPingView=(DianPingView *)[[[NSBundle mainBundle] loadNibNamed:@"DianPingView" owner:self options:nil] firstObject];
        secondDianPingView.frame=CGRectMake(0,CGRectGetMaxY(firstDianPingView.frame), width, kDianPinViewH);
        
        
        thirdDianPingView=(DianPingView *)[[[NSBundle mainBundle] loadNibNamed:@"DianPingView" owner:self options:nil] firstObject];
        thirdDianPingView.frame=CGRectMake(0, CGRectGetMaxY(secondDianPingView.frame), width, kDianPinViewH);
        [self addSubview:firstDianPingView];
        [self addSubview:secondDianPingView];
        [self addSubview:thirdDianPingView];
        
        //2. 添加tip
        UIImageView *tipImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, kTipViewH)];
        tipImageView.image=[UIImage imageNamed:@"map_cardtip"];
        [self addSubview:tipImageView];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5,0, 30, 30)];
        label.text=@"F";
        label.textColor=[UIColor whiteColor];
        [self addSubview:label];
        //3.数据来源
        UILabel *sourceLabel=[[UILabel alloc] initWithFrame:CGRectMake(width-100-10.f, 12.5f, 100, 20)];
        sourceLabel.text=@"数据来源 大众点评";
        sourceLabel.font=[UIFont systemFontOfSize:12.f];
        sourceLabel.textColor=[UIColor grayColor];
        [self addSubview:sourceLabel];
        
        //3.5添加分割线
        UIView *seprateLine=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thirdDianPingView.frame), width, 1)];
        seprateLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:seprateLine];
        
        //4.加载更多按钮
        moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thirdDianPingView.frame), width,kMoreButtonH+5 )];
        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:moreBtn];
        
        
    }
    return self;
}



-(void)setFunctionModel:(FunctionModel *)model{
    
    if (model.dianPingModel.businessArray.count>=3) {
         firstDianPingView.business=model.dianPingModel.businessArray[0];
         secondDianPingView.business=model.dianPingModel.businessArray[1];
         thirdDianPingView.business=model.dianPingModel.businessArray[2];
    }

}
+(CGFloat)heightForContentView:(FunctionModel *)model{
    return 45.f+3*kDianPinViewH+kMoreButtonH;
}


@end
