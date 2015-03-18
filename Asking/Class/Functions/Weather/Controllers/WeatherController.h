//
//  WeatherController.h
//  Asking
//
//  Created by Lves Li on 15/3/17.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@interface WeatherController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *nowWeatherIcon;


#pragma mark labels
@property (weak, nonatomic) IBOutlet UILabel *firstDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstWeatherDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondWeatherDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdWeatherDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayWeatherDesLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowWeatherDesLabel;



@property (nonatomic,strong) WeatherModel *weatherModel;
@end
