//
//  LvesChatBaseCell.m
//  Asking
//
//  Created by Lves Li on 14/11/14.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "LvesChatBaseCell.h"

#import "BubbleTextView.h"
#import "BubbleImageView.h"
#import "BubbleMovieView.h"
#import "BubbleVoiceView.h"


#define kBubblePaddingX 10.f
#define kBubblePaddingY 5.f


@interface LvesChatBaseCell ()
{
    LvesBubbleBaseView *_bubbleView;
}

@end

@implementation LvesChatBaseCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=kChatBackColor;
        
    }
    return self;
}



#pragma mark 设置model
-(void)setModel:(MessageModel *)model{
    
   
    //1. 获得bubble的size
    CGSize bubbleSize=[LvesChatBaseCell sizeForBubble:model];
    //2. 获得bubble的Frame
    CGRect bubbleFrame;
    if (model.isSender) { //发送者
        bubbleFrame=CGRectMake(kScreenWidth-bubbleSize.width-kBubblePaddingX, kBubblePaddingY, bubbleSize.width, bubbleSize.height);
    }else{                //接受者
        bubbleFrame=CGRectMake(kBubblePaddingX, kBubblePaddingY, bubbleSize.width, bubbleSize.height);
    }
    
    
     //3. 创建bubbleView
    
    if (_bubbleView!=nil) {
        [_bubbleView removeFromSuperview];
    }
    if (model.type==MessageBodyType_Text){  //1.文本
        _bubbleView=[[BubbleTextView alloc] initWithFrame:bubbleFrame];
    }else if (model.type==MessageBodyType_Image){
        _bubbleView=[[BubbleImageView alloc] initWithFrame:bubbleFrame];
    }else if (model.type==MessageBodyType_Video){
        _bubbleView=[[BubbleMovieView alloc] initWithFrame:bubbleFrame];
    }else if (model.type==MessageBodyType_Voice){
        _bubbleView=[[BubbleVoiceView alloc] initWithFrame:bubbleFrame];
    }
    
    [_bubbleView setModel:model];
    [self addSubview:_bubbleView];

}

#pragma mark 获得cell高度
+(CGFloat)heightForCell:(MessageModel *)model{
    return [self sizeForBubble:model].height+kBubblePaddingY*2;
}

/*
获得bubble的size大小
*/
+(CGSize)sizeForBubble:(MessageModel*)model{
    CGSize bubbleSize;
    //判断model的类型
    if (model.type==MessageBodyType_Text){
        bubbleSize=[BubbleTextView sizeForBubbleWithObject:model];
    }else if (model.type==MessageBodyType_Image){
        bubbleSize=[BubbleImageView sizeForBubbleWithObject:model];
    }else if (model.type==MessageBodyType_Video){
        bubbleSize=[BubbleMovieView sizeForBubbleWithObject:model];
    }else if (model.type==MessageBodyType_Voice){
        bubbleSize=[BubbleVoiceView sizeForBubbleWithObject:model];
    }
    return bubbleSize;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
