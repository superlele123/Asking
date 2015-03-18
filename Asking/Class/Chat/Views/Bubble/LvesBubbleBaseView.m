//
//  LvesBubbleBaseView.m
//  Asking
//
//  Created by Lves Li on 14/11/7.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "LvesBubbleBaseView.h"





@interface LvesBubbleBaseView ()

@end

@implementation LvesBubbleBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //添加背景图片
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.multipleTouchEnabled = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_backImageView];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

//自定义构造函数,设置背景图片的frame
-(void)setModel:(MessageModel *)model{
    _model = model;
    if (model.isSender) {
        self.backImageView.image = [[UIImage imageNamed:BUBBLE_RIGHT_IMAGE_NAME] stretchableImageWithLeftCapWidth:35.f topCapHeight:35.f];
    }else{
        self.backImageView.image = [[UIImage imageNamed:BUBBLE_LEFT_IMAGE_NAME] stretchableImageWithLeftCapWidth:35.f topCapHeight:35.f];
    }
}


-(void)bubbleViewPressed:(id)sender{
    NSLog(@"%@",@"BaseBubble");

}
//计算气泡的高度
+(CGFloat)heightForBubbleWithObject:(MessageModel *)object{
    return 30.f;
}

+(CGSize) sizeForBubbleWithObject:(MessageModel *)object{
    return CGSizeMake(30, 30);
}



@end
