//
//  MusicController.h
//  Asking
//
//  Created by Lves Li on 15/2/28.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Song;

@interface MusicController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (nonatomic,strong) Song *currentSong;

@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomMiddleView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
///封面
@property (strong, nonatomic) IBOutlet  UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
- (IBAction)playBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

- (IBAction)clockBtnClick:(id)sender;
- (IBAction)likeBtnClick:(id)sender;
@end
