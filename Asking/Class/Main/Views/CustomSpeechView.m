//
//  CustomSpeechView.m
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "CustomSpeechView.h"

@interface CustomSpeechView ()
{


}
@end

@implementation CustomSpeechView
@synthesize speechBtn;
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1. 初始化ActionSheet视图
        self.backgroundColor=[UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1.f];
        self.alpha=0.85f;
        
        //2.语音view
        speechBtn=[[UIButton alloc] init];
        [speechBtn setImage:[UIImage imageNamed:@"voice_press.png"] forState:UIControlStateNormal];
        [speechBtn setCenter:CGPointMake(kScreenWidth/2.f, kActivityViewH-kBtnSpeechSize/2.f-kpadding)];
        speechBtn.bounds=CGRectMake(0, 0, kBtnSpeechSize, kBtnSpeechSize);
        [speechBtn addTarget:self action:@selector(speechCancel:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:speechBtn];
        
        
        //3.取消按钮
        UIButton *deleteSpeechBtn=[[UIButton alloc] init];
        [deleteSpeechBtn setFrame:CGRectMake(kScreenWidth-kCancelBtnSize-kpadding, kActivityViewH-kCancelBtnSize-kpadding, kCancelBtnSize, kCancelBtnSize)];
        [deleteSpeechBtn setImage:[UIImage imageNamed:@"searchbar_cancelbtn_bg.png"] forState:UIControlStateNormal];
        [deleteSpeechBtn addTarget:self action:@selector(speechDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteSpeechBtn];
        
        //4.请说话label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100.f)/2.f, 4*kpadding, 100.f, 30.f)];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"请说话...";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor grayColor];
        [self addSubview:label];
        //添加手势
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speechCancel:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        
    }
    return self;
}

/*录音完成*/
-(void)speechCancel:(id)sender{
    //1.移除录音动画按钮
    [[self viewWithTag:10000] removeFromSuperview];
    [[self viewWithTag:10001] removeFromSuperview];
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(customSpeechViewCancel)]) {
        [self.delegate customSpeechViewCancel];
    }

}

/*录音取消*/

-(void)speechDelete:(id)sender{
    //1.移除录音动画按钮
    [[self viewWithTag:10000] removeFromSuperview];
    [[self viewWithTag:10001] removeFromSuperview];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(customSpeechViewDelete)]) {
        [self.delegate customSpeechViewDelete];
    }

}
//开始录音
-(void)startSpeechAnimate{
    
    //4.1 正在录音动画
    //里边的动画数组
    NSArray *imgArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"vr_recognizes_voice_button4_bg1.png"],
            
                         [UIImage imageNamed:@"vr_recognizes_voice_button4_bg3.png"],
                         [UIImage imageNamed:@"vr_recognizes_voice_button4_bg4.png"],nil];//定义一个动画的帧数组
    UIImageView *animImgView = [[UIImageView alloc]init];//初始化一个UIImageView用于逐帧播放我们的动画
    animImgView.frame = CGRectMake(0, 0, ((UIImage*)[imgArray objectAtIndex:0]).size.width+30, ((UIImage*)[imgArray objectAtIndex:0]).size.height+30);//这里默认认为动画的每帧大小是一致的，顾取出第一个图片的大小来作为UIImageView的大小
    animImgView.center =speechBtn.center;//上边只是这是了UIImageView的大小，这里设置他的摆放位置，让动画的中心点和按钮的中心点重叠
    animImgView.tag = 10000;//设置这个是为了在压下的按钮触发的释放动作中获取到这个播放动画的UIImageView
    animImgView.animationImages = imgArray; //将逐帧动画的数组传递给UIImageView
    animImgView.animationDuration = 1.5f; //浏览所有图片一次所用的时间
    animImgView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [animImgView startAnimating]; //开始播放动画
    [self addSubview:animImgView]; //添加视图到窗体中
    [self sendSubviewToBack:animImgView];//将动画播放的视图移到elf.view的最底层，这里需要注意图层遮挡问题
    
    //外边逐渐放大的环
    UIImage *circleImage=[UIImage imageNamed:@"vr_recognizes_voice_button4_bg4.png"];
    UIImageView *circleView=[[UIImageView alloc] initWithImage:circleImage];
    circleView.tag=10001;
    [circleView setCenter:speechBtn.center];
    circleView.bounds=CGRectMake(0, 0, animImgView.frame.size.width-1, animImgView.frame.size.height-1);
    [self addSubview:circleView];
    
    [UIView animateWithDuration:1
                          delay:0.5
                        options:UIViewAnimationOptionRepeat // 重复
                     animations:^{
                         // 变大一倍
                         circleView.transform = CGAffineTransformMakeScale(2, 2);
                     } completion:^(BOOL finished) {
                         // 变回原样
                         circleView.transform = CGAffineTransformIdentity;
                     }];
    
    

}







@end
