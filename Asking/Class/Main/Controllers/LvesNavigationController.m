//
//  LvesNavigationController.m
//  Asking
//
//  Created by Lves Li on 15/3/21.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "LvesNavigationController.h"
#define kBackButtonColor [UIColor colorWithRed:75/255.f green:75/255.f blue:75/255.f alpha:1.f]

@implementation LvesNavigationController

-(void)viewDidLoad{
     [super viewDidLoad];
    
    //1. 设置导航栏的背景图片
    UINavigationBar *bar=[UINavigationBar appearance];
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
//    [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background.png"]]];
    bar.barStyle = UIStatusBarStyleDefault;
    //1.2 设置返回按钮的颜色  在plist中添加 View controller-based status bar appearance切记。
    [bar setTintColor:kBackButtonColor];
    
    
    
    
    //2. 设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor blackColor],
                                  }];
    //3. 设置UIBarButtonItem的外观
    UIBarButtonItem *barItem=[UIBarButtonItem appearance];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //4. 该item上边的文字样式
    NSDictionary *fontDic=@{
                            NSForegroundColorAttributeName:kBackButtonColor,
                            NSFontAttributeName:[UIFont boldSystemFontOfSize:17.f],  //粗体
                            };
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateHighlighted];
    
    
    //5. 设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;


}

@end
