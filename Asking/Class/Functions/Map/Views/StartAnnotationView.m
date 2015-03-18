//
//  StartAnnotationView.m
//  flowofficial
//
//  Created by Lves Li on 14-8-27.
//  Copyright (c) 2014年 Jesse Cheng. All rights reserved.
//

#import "StartAnnotationView.h"
//#import "UIImage+embundle.h"
#import "CustomCalloutView.h"

#define kWidth  50.f
#define kHeight 50.f

#define kHoriMargin 0.f
#define kVertMargin 0.f

#define kPortraitWidth  48.f
#define kPortraitHeight 68.f

#define kCalloutWidth   200.0
#define kCalloutHeight  45.0




@interface StartAnnotationView ()

///大头针图像
@property (nonatomic, strong) UIImageView *portraitImageView;
///标题
@property (nonatomic, strong) UILabel *nameLabel;


@end


@implementation StartAnnotationView
@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize startButton=_startButton;
@synthesize nameLabel = _nameLabel;
@synthesize name = _name;



#pragma mark - Override


- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        _nameLabel.text = self.name;
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle



- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        //1.添加大头针视图
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        self.portraitImageView.image = [UIImage imageNamed:@"purplePin.png"];
        [self addSubview:self.portraitImageView];
        
        
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        
        
        
        // 5. 添加标题
        CGFloat nameH=35.f;
        
        CGFloat buttonWidth=50.f;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kCalloutWidth-buttonWidth-10, nameH)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        //_nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.calloutView addSubview:_nameLabel];

        //2. 添加私家车按钮
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        [_startButton setFrame:CGRectMake(kCalloutWidth-buttonWidth-5, 0, buttonWidth, nameH)];
       
        
        [self.calloutView addSubview:_startButton];
        
        
    }
    
    return self;
}

-(void)setBtnTitile:(NSString *)titile{
    [_startButton setTitle:titile forState:UIControlStateNormal];
    [_startButton setTitle:titile forState:UIControlStateHighlighted];
    [_startButton setTitle:titile forState:UIControlStateSelected];
}


@end
