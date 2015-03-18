//
//  WeatherController.m
//  Asking
//
//  Created by Lves Li on 15/3/17.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "WeatherController.h"


@interface WeatherController ()
{
    UIView *circelView;
    
}

@end

@implementation WeatherController
@synthesize weatherModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开始动画
    [self startAnimation];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setWeatherDesc];
}


-(void)setWeatherDesc{
    WeatherDesc *todayWeatherDesc=weatherModel.todayWeather;
    WeatherDesc *fristDesc=weatherModel.firstDayWeather;
    WeatherDesc *secondDesc=weatherModel.secondDayWeather;
    WeatherDesc *thirdDesc=weatherModel.thirdDayWeather;
    
    
    //设置四天的天气
    self.todayDateLabel.text=todayWeatherDesc.date;
    self.todayTempLabel.text=todayWeatherDesc.temperature;
    self.todayWeatherDesLabel.text=todayWeatherDesc.weatherDes;
    
    self.firstDateLabel.text=fristDesc.date;
    self.firstTempLabel.text=fristDesc.temperature;
    self.firstWeatherDesLabel.text=fristDesc.weatherDes;
    
    self.secondDateLabel.text=secondDesc.date;
    self.secondTempLabel.text=secondDesc.temperature;
    self.secondWeatherDesLabel.text=secondDesc.weatherDes;
    
    self.thirdDateLabel.text=thirdDesc.date;
    self.thirdTempLabel.text=thirdDesc.temperature;
    self.thirdWeatherDesLabel.text=thirdDesc.weatherDes;
    //设置实时天气
    self.nowTempLabel.text=weatherModel.nowTemperature;
    
    self.nowWeatherDesLabel.text=weatherModel.cityName;


}



#pragma mark 动画

- (void)startAnimation {
    //1.获得初始值
    CGPoint firstCenter=self.firstView.center;
    CGPoint secondCenter=self.secondView.center;
    CGPoint thirdCenter=self.thirdView.center;
    
    CGPoint middleViewCenter=self.middleView.center;
    
    CGSize middleViewSize=self.middleView.frame.size;
    CGSize firstViewSize=self.firstView.frame.size;
    CGSize thirdViewSize=self.thirdView.frame.size;
    
    //2.修改初始大小
    self.firstView.bounds=CGRectMake(0, 0, firstViewSize.width, 20.f);
    self.thirdView.bounds=CGRectMake(0, 0, thirdViewSize.width, 20.f);
    
    //3.修改初始位置
    self.firstView.center=CGPointMake(firstCenter.x, 20);
    self.secondView.center=CGPointMake(secondCenter.x, 20);
    self.thirdView.center=CGPointMake(thirdCenter.x, 50);
    
    self.middleView.center=CGPointMake(middleViewCenter.x, middleViewCenter.y+middleViewSize.height);
    
    
    //4.隐藏内容
    
    [self.firstView.subviews setValue:@0 forKeyPath:@"alpha"];
    [self.secondView.subviews setValue:@0 forKeyPath:@"alpha"];
    [self.thirdView.subviews setValue:@0 forKeyPath:@"alpha"];
    [self.middleView.subviews setValue:@0 forKeyPath:@"alpha"];
    [self.topView.subviews setValue:@0 forKeyPath:@"alpha"];
    
    
    //5.动画
    [UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.firstView.bounds=CGRectMake(0, 0, firstViewSize.width, firstViewSize.height);
        self.thirdView.bounds=CGRectMake(0, 0, thirdViewSize.width, thirdViewSize.height);
        
        self.firstView.center=firstCenter;
        self.thirdView.center=thirdCenter;
        
        
        //下边中间、中间视图
        [UIView animateWithDuration:1.5 delay:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.secondView.center=secondCenter;
            self.middleView.center=middleViewCenter;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                //显示字体
                [self.secondView.subviews setValue:@1 forKeyPath:@"alpha"];
            } completion:^(BOOL finished) {
                //顶部视图动画
                [UIView animateWithDuration:0.5 animations:^{
                    [self.topView.subviews setValue:@1 forKeyPath:@"alpha"];
                    
                    self.nowWeatherIcon.transform = CGAffineTransformMakeScale(1.3, 1.3);
                } completion:^(BOOL finished){
                    // 变回原样
                    self.nowWeatherIcon.transform = CGAffineTransformIdentity;
                    
                }];
            }];
        }];
        
    } completion:^(BOOL finished) {
        //显示内容
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.firstView.subviews setValue:@1 forKeyPath:@"alpha"];
            [self.thirdView.subviews setValue:@1 forKeyPath:@"alpha"];
            [self.middleView.subviews setValue:@1 forKey:@"alpha"];
        } completion:nil];
    }];
    
}
@end
