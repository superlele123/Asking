//
//  BubbleTextView.m
//  Asking
//
//  Created by Lves Li on 14/11/7.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "BubbleTextView.h"
#define Bubble_Padding 8.f
#define BubbleArrowWidth 10.f //箭头的宽度
#define kTextFont [UIFont systemFontOfSize:14]
#define Bubble_Max_Width 200 //　textLaebl 最大宽度



@interface BubbleTextView ()


@end

@implementation BubbleTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.font =kTextFont;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.multipleTouchEnabled = NO;
        [self addSubview:_textLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;

    frame.size.width-=BubbleArrowWidth;
    frame.size.height-=Bubble_Padding;
    frame=CGRectInset(frame, Bubble_Padding, Bubble_Padding);
    if (self.model.isSender) {
        frame.origin.x+=Bubble_Padding;
    }else{
        frame.origin.x=Bubble_Padding+BubbleArrowWidth;
    }
    frame.origin.y=Bubble_Padding;
    
    
    [self.textLabel setFrame:frame];
}

/*设置文本消息内容*/
-(void)setModel:(MessageModel *)model{
    [super setModel:model];
    
    //获得
    _textLabel.text=model.content;
    
    
}

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object{
   return  [self sizeForBubbleWithObject:object].height;
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)object{
    CGSize textBlockMinSize = {Bubble_Max_Width, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    if (systemVersion >= 7.0) {
        size = [object.content boundingRectWithSize:textBlockMinSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:kTextFont}
                                            context:nil].size;
    }else{
        size = [object.content sizeWithFont:kTextFont constrainedToSize:textBlockMinSize lineBreakMode:[self textLabelLineBreakModel]];
    }
    size.height+=4 * Bubble_Padding;
    size.width+=BubbleArrowWidth+3*Bubble_Padding;
    return size;
}

+(NSLineBreakMode)textLabelLineBreakModel
{
    return NSLineBreakByCharWrapping;
}

-(void)bubbleViewPressed:(id)sender{
    NSLog(@"%@",@"TextBubble");
}

















@end
