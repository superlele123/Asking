//
//  BubbleImageView.m
//  LvesMessageShow
//
//  Created by Lves Li on 14/11/11.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "BubbleImageView.h"
#import "UIImage+Utils.h"

#define  MAX_SIZE 120.f
#define Bubble_Padding 8.f
#define BubbleArrowWidth 5.f //箭头的宽度


@implementation BubbleImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
    }
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
//    
//    CGRect frame = self.bounds;
//    frame.size.width -= BubbleArrowWidth;
//    frame = CGRectInset(frame, Bubble_Padding, Bubble_Padding);
//    if (self.model.isSender) {
//        frame.origin.x = Bubble_Padding;
//    }else{
//        frame.origin.x = Bubble_Padding + BubbleArrowWidth;
//    }
//    
//    frame.origin.y = 3;
//    [self.imageView setFrame:frame];
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    UIImage *image = model.thumbnailImage;
    if (!image) {
        image = model.image;
        if (!image) {
            image = [UIImage imageNamed:@"imageDownloadFail.png"];
        }
    }
    
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
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
   NSLog(@"%@",@"ImageBubble");
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return [self sizeForBubbleWithObject:object].height;
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)object{
    CGSize retSize = object.size;
    if (retSize.width == 0 || retSize.height == 0) {
        retSize.width = MAX_SIZE;
        retSize.height = MAX_SIZE;
    }
    if (retSize.width > retSize.height) {
        CGFloat height =  MAX_SIZE / retSize.width  *  retSize.height;
        retSize.height = height;
        retSize.width = MAX_SIZE;
    }else {
        CGFloat width = MAX_SIZE / retSize.height * retSize.width;
        retSize.width = width;
        retSize.height = MAX_SIZE;
    }
    
    return CGSizeMake(retSize.width + Bubble_Padding * 2 + BubbleArrowWidth, 2 * Bubble_Padding+ retSize.height);
    //return retSize;
}


@end










