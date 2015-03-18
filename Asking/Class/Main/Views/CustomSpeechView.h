//
//  CustomSpeechView.h
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  自定义语音的ActionSheetView

#import <UIKit/UIKit.h>

@protocol CustomeSpeechDelegate <NSObject>

-(void)customSpeechViewCancel;

-(void)customSpeechViewDelete;

@end



@interface CustomSpeechView : UIView

@property (nonatomic,strong)  UIButton *speechBtn;


@property (nonatomic,weak) id <CustomeSpeechDelegate> delegate;


-(void)startSpeechAnimate;


@end
