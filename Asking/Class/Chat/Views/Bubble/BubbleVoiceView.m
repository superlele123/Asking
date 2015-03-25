//
//  BubbleVoiceView.m
//  LvesMessageShow
//
//  Created by Lves Li on 14/11/13.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "BubbleVoiceView.h"

#define kVoiceViewW 90.f
#define kVoiceViewH 50.f
#define kVoiceW 40.f
#define kPadding 6.f


@interface BubbleVoiceView ()
{
    ///喇叭按钮
    UIButton *_voiceBtn;
    ///时间lable
    UILabel *_timeLabel;

}

@end



@implementation BubbleVoiceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y,kVoiceViewW, kVoiceViewH)]) {
        //添加语音喇叭
        _voiceBtn=[[UIButton alloc] init];
        [self addSubview:_voiceBtn];
        //添加时间
        _timeLabel=[[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.f]];
        [self addSubview:_timeLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

/*设置文本消息内容*/
-(void)setModel:(MessageModel *)model{
    [super setModel:model];
   
    CGSize size=self.frame.size;
    
    //发送
    if (model.isSender) {
        //设置喇叭位置和图片
        [_voiceBtn setBounds:CGRectMake(0, 0, kVoiceW, kVoiceW)];
        CGFloat voiceCentY=22.f;
        [_voiceBtn setCenter:CGPointMake(kVoiceViewW-kVoiceW*0.5f-kPadding,voiceCentY)];
        [_voiceBtn setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying@2x.png"] forState:UIControlStateNormal];
        //设置时间
        [_timeLabel setFrame:CGRectMake(2*kPadding, kPadding, 30.f, 30.f)];
        
        
    }else{  //接受
        [_voiceBtn setFrame:CGRectMake(kPadding,2.f, kVoiceW, kVoiceW)];
        [_voiceBtn setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying@2x.png"] forState:UIControlStateNormal];
    
        [_timeLabel setFrame:CGRectMake(size.width-kPadding-30.f, kPadding, 30.f, 30.f)];
    }
    [_timeLabel setText:[NSString stringWithFormat:@"%ld ''",(long)model.time]];
    
    
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender{
    DLog(@"%@",@"VoiceBubble");
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return [self sizeForBubbleWithObject:object].height;
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)object{
 
    return CGSizeMake(kVoiceViewW, kVoiceViewH);
}

@end
