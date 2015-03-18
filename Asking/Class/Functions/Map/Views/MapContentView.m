//
//  MapContentView.m
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "MapContentView.h"

#define kMapPadding 10.f
#define kCellH 180.f
#define kBtnW 100.f
#define kBtnH 50.f
#define kIconW 15.f
#define kTextFieldH 40.f

#define kChangeImageW 30.f
#define kButtonH 48.f
#define kMapButtonWScale 0.7f



@interface MapContentView ()
{
    UITextField *_startField;
    UITextField *_endField;
}
@end

@implementation MapContentView
@synthesize taxiBtn;
@synthesize mapBtn;

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        CGFloat width= kScreenWidth-kCellMargin*2;
        
        //添加tip
        UIImageView *tipImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
        tipImageView.image=[UIImage imageNamed:@"map_cardtip"];
        [self addSubview:tipImageView];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5,0, 30, 30)];
        label.text=@"P";
        label.textColor=[UIColor whiteColor];
        [self addSubview:label];
    
        
        
        //左边的转换按钮
        UIButton *changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(kMapPadding*2, kMapPadding*2,kChangeImageW , kChangeImageW)];
        [changeBtn setCenter:CGPointMake(kMapPadding+kChangeImageW/2.f, kMapPadding+kTextFieldH)];
        [changeBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [changeBtn setBackgroundImage:[UIImage imageNamed:@"icon_route_change@2x.png"] forState:UIControlStateNormal];
        [changeBtn setBackgroundImage:[UIImage imageNamed:@"icon_route_change_select@2x.png"] forState:UIControlStateSelected];
        [changeBtn addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeBtn];
        
        //开始点icon
        CGFloat startIconX=CGRectGetMaxX(changeBtn.frame)+kMapPadding*2;
        CGFloat startIconY=kMapPadding+(kTextFieldH-kIconW)/2.f;
        UIImageView *startIcon=[[UIImageView alloc] initWithFrame:CGRectMake(startIconX,startIconY, kIconW, kIconW)];
        startIcon.image=[UIImage imageNamed:@"icon_route_st"];
        [self addSubview:startIcon];
        
       
        
        
        //开始点
        CGFloat startX=CGRectGetMaxX(startIcon.frame)+kMapPadding;
        _startField=[[UITextField alloc] initWithFrame:CGRectMake(startX, kMapPadding, 200, kTextFieldH)];
        [_startField setPlaceholder:@"输入起点"];
        _startField.enabled=NO;
        [self addSubview:_startField];
        //终点icon
        CGFloat endIconX=CGRectGetMaxX(changeBtn.frame)+kMapPadding*2;
        CGFloat endIconY=CGRectGetMaxY(_startField.frame)+(kTextFieldH-kIconW)/2.f;
        UIImageView *endIcon=[[UIImageView alloc] initWithFrame:CGRectMake(endIconX, endIconY, kIconW, kIconW)];
        endIcon.image=[UIImage imageNamed:@"icon_route_end"];
        [self addSubview:endIcon];
        //结束点
        CGFloat endX=startX;
        CGFloat endY=CGRectGetMaxY(_startField.frame);
        _endField=[[UITextField alloc] initWithFrame:CGRectMake(endX, endY, 200, kTextFieldH)];
        [_endField setPlaceholder:@"输入终点"];
        _endField.enabled=NO;
        [self addSubview:_endField];
        
        
        
        
        //分割线
        CGFloat lineY=CGRectGetMaxY(_endField.frame)+kMapPadding;
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(kMapPadding, lineY,width-kMapPadding*2, 1.f)];
        lineView.backgroundColor=kLineColor;
        [self addSubview:lineView];

        
        //地图按钮
        CGFloat mapY=CGRectGetMaxY(_endField.frame)+2*kMapPadding;
        mapBtn=[[UIButton alloc] initWithFrame:CGRectMake(width*(1-kMapButtonWScale)/2.f, mapY, width*kMapButtonWScale, kButtonH)];
        [mapBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mapcolor"]]];
        mapBtn.layer.masksToBounds=YES;
        mapBtn.layer.cornerRadius=kButtonH/2.f;
        [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
        [self addSubview:mapBtn];
        
        
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, kCellH-5, width, 5)];
        bottomView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mapcolor"]];
        [self addSubview:bottomView];
        
        
    }
    return self;
}


/*获得高度*/

+(CGFloat)heightForContentView:(FunctionModel *)model{
    return kCellH;
}
/*设置数据源*/
-(void)setFunctionModel:(FunctionModel *)model{
    [super setFunctionModel:model];
    _startField.text=model.startStr;
    _endField.text=model.endStr;
    self.startPlace=model.startStr;
    self.endPlace=model.endStr;
    

}
#pragma mark 点击交换按钮
-(void)exchange:(id)sender{
    self.startPlace=_endField.text;
    self.endPlace=_startField.text;
    _endField.text=self.endPlace;
    _startField.text=self.startPlace;

}



@end
