//
//  LvesBubbleBaseView.h
//  Asking
//
//  Created by Lves Li on 14/11/7.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  气泡根视图

#import <UIKit/UIKit.h>
#import "MessageModel.h"

#define BUBBLE_LEFT_IMAGE_NAME @"ReceiverTextNodeBkg@2x.png" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"SenderTextNodeBkg@2x.png"



@interface LvesBubbleBaseView : UIView
{

}
///聊天数据Model
@property (nonatomic, strong) MessageModel *model;
///背景图片
@property (nonatomic, strong) UIImageView *backImageView;
///进度条
//@property (nonatomic, strong) THProgressView *progressView;


/*
 点击视图
 
*/
- (void)bubbleViewPressed:(id)sender;
/*
 计算气泡的高度
 
*/
+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object;

/*
 计算气泡的大小
 
 */
+(CGSize) sizeForBubbleWithObject:(MessageModel *)object;

@end
