//
//  BubbleMovieView.m
//  LvesMessageShow
//
//  Created by Lves Li on 14/11/13.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "BubbleMovieView.h"
#import "UIImage+Utils.h"

#define kBubbleW 120.f
#define kBubbleH 100.f

#define  kBtnW 40.f
#define  kPadding 40.f
#define  kPaddingH 30.f

@implementation BubbleMovieView



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kBubbleW, kBubbleH)]) {
    }
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    UIImage *image=[UIImage imageNamed:@"video.png"];
    //拉伸图片
    const UIImage *resizableMaskImage ;
    if (model.isSender) {
        resizableMaskImage = [[UIImage imageNamed:BUBBLE_RIGHT_IMAGE_NAME] stretchableImageWithLeftCapWidth:35.f topCapHeight:35.f];
    }else{
        resizableMaskImage = [[UIImage imageNamed:BUBBLE_LEFT_IMAGE_NAME] stretchableImageWithLeftCapWidth:35.f topCapHeight:35.f];
    }
    //设置图片大小
    const UIImage *maskImageDrawnToSize= [resizableMaskImage renderAtSize:self.frame.size];
    //设置图片
    _imageView = [[UIImageView alloc] initWithImage:[image maskWithImage:maskImageDrawnToSize]];
    [self addSubview:_imageView];
    
    
    //添加按钮
    UIButton *playBtn=[[UIButton alloc] initWithFrame:CGRectMake(kPadding, kPaddingH, kBtnW, kBtnW)];
    [playBtn setImage:[UIImage imageNamed:@"MMVideoPreviewPlayHL@2x.png"] forState:UIControlStateNormal];
    [self addSubview:playBtn];
    
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    DLog(@"%@",@"MovieBubble");

}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return [self sizeForBubbleWithObject:object].height;
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)object{
    
    return CGSizeMake(kBubbleW, kBubbleH);
}

@end
