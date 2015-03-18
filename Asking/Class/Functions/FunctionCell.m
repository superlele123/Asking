//
//  FunctionCell.m
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "FunctionCell.h"
#import "MapContentView.h"
#import "WeatherContentView.h"
#import "DianPingContentView.h"


#define kRotationRadian  90.0/360.0
#define kVelocity        100

@interface FunctionCell ()<UIGestureRecognizerDelegate>
{
    CellContentBaseView *_baseView;  //根视图
    
}

@property(assign, nonatomic) CGPoint currentPoint;
@property(assign, nonatomic) CGPoint previousPoint;
@property(strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property(assign, nonatomic) float offsetRate;

@end


@implementation FunctionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5.f;
        [self addPanGestureRecognizer];
    }
    return self;
}


#pragma mark 添加手势识别
-(void)addPanGestureRecognizer{
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDeleteCell:)];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocityPoint = [gestureRecognizer velocityInView:self];
        if (fabsf(velocityPoint.x) > kVelocity) {
            return YES;
        }else
            return NO;
    }else
        return NO;
    
}

-(void)slideToDeleteCell:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    _previousPoint = [panGestureRecognizer locationInView:self.superview];
    
    static CGPoint originalCenter;
    UIGestureRecognizerState state = panGestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        
        originalCenter = self.center;
        [self.superview bringSubviewToFront:self];
    }else if (state == UIGestureRecognizerStateChanged){
        CGPoint diff = CGPointMake(_previousPoint.x - _currentPoint.x, _previousPoint.y - _currentPoint.y);
        [self handleOffset:diff];
    }else if (state == UIGestureRecognizerStateEnded){
        if (_offsetRate < 0.5) {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.transform = CGAffineTransformIdentity;
                self.center = originalCenter;
                self.alpha = 1.0;
                
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.center = CGPointMake(self.center.x * 2, self.center.y);
                self.alpha = 0.0;
                
            } completion:^(BOOL finsh){
                self.transform = CGAffineTransformIdentity;
                if (self.delegate&&[self.delegate respondsToSelector:@selector(slideToDeleteCell:)]) {
                    [self.delegate slideToDeleteCell:self];
                }
                
                
            }];
        }
    }
    _currentPoint = _previousPoint;
    
}

-(void)handleOffset:(CGPoint)offset{
    
    self.center = CGPointMake(self.center.x + offset.x, self.center.y);
    float distance = self.frame.size.width/2 - self.center.x;
    float distanceAbs = fabsf(distance);
    float distanceRate = (self.frame.size.width - distanceAbs) / self.frame.size.width;
    self.alpha = distanceRate;
    
    _offsetRate = 1 -distanceRate;
    
    if (distance >= 0) {
        self.transform = CGAffineTransformMakeRotation(-_offsetRate * kRotationRadian);
    }else
        self.transform = CGAffineTransformMakeRotation(_offsetRate * kRotationRadian);
    
}



#pragma mark 计算Cell高度
+(CGFloat)heightForFunctionCell:(FunctionModel *)model{
    CGFloat height;
    //判断类型获得高度
    if(model.type==FunctionTypeMap){  //地图
        height=[MapContentView heightForContentView:model];
    }else if (model.type==FunctionTypeWeather){  //天气
        height=[WeatherContentView heightForContentView:model];
    }else if (model.type==FunctionTypeDianPing){
        height=[DianPingContentView heightForContentView:model];
    }
    
    return height;
}

-(void)setFunctionModel:(FunctionModel *)functionModel{
    _functionModel=functionModel;
    
    CGFloat width=kScreenWidth-kCellMargin*2;
    if (_baseView) {
        [_baseView removeFromSuperview];
    }
    
    if (functionModel.type==FunctionTypeMap) {         //1. 地图
        CGFloat height=[MapContentView heightForContentView:functionModel];
        _baseView=[[MapContentView alloc] initWithFrame:CGRectMake(0, 0, width,height)];
        MapContentView *mapCard=(MapContentView *)_baseView;
        [mapCard.mapBtn addTarget:self action:@selector(clickMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView setFunctionModel:functionModel];
        [self addSubview:_baseView];
    }else if (functionModel.type==FunctionTypeWeather){ //2. 天气cell
        CGFloat height=[WeatherContentView heightForContentView:functionModel];
        
        _baseView=[[WeatherContentView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [_baseView setFunctionModel:functionModel];
        [self addSubview:_baseView];
    }else if (functionModel.type==FunctionTypeDianPing){  //3.大众点评
        //1. 初始化
        CGFloat height=[DianPingContentView heightForContentView:functionModel];
        _baseView=[[DianPingContentView alloc] initWithFrame:CGRectMake(0, 0, width,height)];
        //2.数据源
        [_baseView setFunctionModel:functionModel];
        [self addSubview:_baseView];
        //3.添加点击手势
        DianPingContentView *dianPingContentView=(DianPingContentView *)_baseView;
        UITapGestureRecognizer *panFirstRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFirstView:)];
        [dianPingContentView.firstDianPingView addGestureRecognizer:panFirstRecognizer];
        
        UITapGestureRecognizer *panSecondRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondView:)];
        [dianPingContentView.secondDianPingView addGestureRecognizer:panSecondRecognizer];
        
        UITapGestureRecognizer *panThirdRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThirdView:)];
        [dianPingContentView.thirdDianPingView addGestureRecognizer:panThirdRecognizer];
        //4.更多按钮
        [dianPingContentView.moreBtn addTarget:self action:@selector(dianPingMoreBtnClock:) forControlEvents:UIControlEventTouchDown];
        
        
    }
    
    
    
}


#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x = kCellMargin;
    frame.size.width =kScreenWidth- 2 * kCellMargin;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 点击按钮
#pragma mark 点击地图按钮
-(void)clickMapBtn:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cardClickMapBtn:andFrom:toPlace:)]) {
        if (_functionModel.type==FunctionTypeMap) {
            MapContentView *mapCard=(MapContentView *)_baseView;
            if (self.delegate&&[self.delegate respondsToSelector:@selector(cardClickMapBtn:andFrom:toPlace:)]){
                [self.delegate cardClickMapBtn:sender andFrom:mapCard.startPlace toPlace:mapCard.endPlace];
            }
            
        }
        
    }
    
}
#pragma mark 大众点评添加点击手势
-(void)tapFirstView:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tapDianPingView:)]){
        [self.delegate tapDianPingView:_functionModel.dianPingModel.businessArray[0]];
    }
    
}
-(void)tapSecondView:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tapDianPingView:)]){
        [self.delegate tapDianPingView:_functionModel.dianPingModel.businessArray[1]];
    }
    
}
-(void)tapThirdView:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tapDianPingView:)]){
        [self.delegate tapDianPingView:_functionModel.dianPingModel.businessArray[2]];
    }
}
-(void)dianPingMoreBtnClock:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickDianPingMoreBtn:)]){
        [self.delegate clickDianPingMoreBtn:_functionModel];
    }

}
@end
