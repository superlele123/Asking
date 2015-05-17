//
//  WeatherContentView.m
//  Asking
//
//  Created by Lves Li on 14/11/26.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "WeatherContentView.h"
#import "WeatherModel.h"

#define kWeatherPadding 10.f
#define kWeatherCellH 250.f
#define kWeatherIconW 80.f
#define kCityNameLabelW 200.f
#define kPadding 5.f



@interface WeatherContentView ()
{
    UILabel *_cityLabel;
    ///添加model
    WeatherModel *_weatherModel;
    
    ///日期
    UILabel *dateLabel;
    
    ///天气Image
    UIImageView *_weatherIcon;
    ///天气Label
    UILabel *_todayWeaDesLabel;
    ///温度变化
    UILabel *todayTempLabel;
    ///实时温度
    UILabel *nowTempLabel;
    
    ///风力
    UILabel *windLabel;
    
    ///PM2.5
    UILabel *pm25Label;
    
    
    
}

@end

@implementation WeatherContentView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        CGFloat width= kScreenWidth-kCellMargin*2;
        CGFloat cardW=width/3.f;
        
        
        //1.添加tip
        UIImageView *tipImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
        tipImageView.image=[UIImage imageNamed:@"weather_cardtip"];
        [self addSubview:tipImageView];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5,0, 30, 30)];
        label.text=@"W";
        label.textColor=[UIColor whiteColor];
        [self addSubview:label];
        //2、日期
        dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(cardW, kPadding, cardW, 20)];
        dateLabel.textAlignment=NSTextAlignmentCenter;
        dateLabel.font=[UIFont systemFontOfSize:12.f];
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.minimumScaleFactor = 0.5f;
        dateLabel.textColor=[UIColor grayColor];
        [self addSubview:dateLabel];
        
        //3、城市 (右上角)
        CGFloat cityNameY=kPadding;
        _cityLabel=[[UILabel alloc] initWithFrame:CGRectMake(cardW*2, cityNameY,cardW-kWeatherPadding,20)];
        _cityLabel.textColor=[UIColor grayColor];
        _cityLabel.font=[UIFont systemFontOfSize:12.f];
        _cityLabel.textAlignment=NSTextAlignmentRight;
        _cityLabel.adjustsFontSizeToFitWidth = YES;
        _cityLabel.minimumScaleFactor = 0.5f; // Chnage as your need

        [self addSubview:_cityLabel];
        
        
        //4. 天气Icon
        CGFloat weatherIconY=3*kWeatherPadding;
        CGFloat weatherIconX=CGRectGetMaxX(tipImageView.frame);
        _weatherIcon=[[UIImageView alloc] initWithFrame:CGRectMake(weatherIconX,weatherIconY, kWeatherIconW, kWeatherIconW)];
        [self addSubview:_weatherIcon];
        //5、天气详情
        CGFloat weatherDesLabelY=CGRectGetMaxY(_weatherIcon.frame)+5.f;
        _todayWeaDesLabel=[[UILabel alloc] initWithFrame:CGRectMake(weatherIconX, weatherDesLabelY, kWeatherIconW, 20)];
        _todayWeaDesLabel.textAlignment=NSTextAlignmentCenter;
        _todayWeaDesLabel.adjustsFontSizeToFitWidth = YES;
        _todayWeaDesLabel.minimumScaleFactor = 0.5f; // Chnage as your need
        [self addSubview:_todayWeaDesLabel];
        
        
        //6 实时温度
        CGFloat nowTemX=CGRectGetMaxX(_weatherIcon.frame)+kWeatherPadding;
        CGFloat nowTemY=weatherIconY+kPadding;
        CGFloat nowTemW=width-nowTemX-kWeatherPadding;
        nowTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(nowTemX, nowTemY, nowTemW, 80)];
        nowTempLabel.textAlignment=NSTextAlignmentCenter;
        nowTempLabel.adjustsFontSizeToFitWidth = YES;
        nowTempLabel.minimumScaleFactor = 0.5f; // Chnage as your need
        nowTempLabel.font=[UIFont systemFontOfSize:60];
        [self addSubview:nowTempLabel];
        
        
        
        
       
        
        //7、水平分割线
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(kWeatherPadding, 150.f, width-kWeatherPadding*2, 1)];
        lineView.backgroundColor=kLineColor;
        [self addSubview:lineView];
        
        //8.三个属性Title
        
        for (int i=0; i<3; i++) {
            CGFloat tempNameLabelY=CGRectGetMaxY(lineView.frame)+kWeatherPadding;
            
            UILabel *tempNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(kPadding+i*cardW, tempNameLabelY, cardW-kPadding*2, 20.f)];
            tempNameLabel.textAlignment=NSTextAlignmentCenter;
            tempNameLabel.textColor=[UIColor grayColor];
            [self addSubview:tempNameLabel];
            if (0==i) {
                tempNameLabel.text=@"温度";
            }else if (1==i){
                tempNameLabel.text=@"风力";
            }else if (2==i){
                tempNameLabel.text=@"PM2.5";
            }
            
        }
        //9、 分割线
        CGFloat lineY=CGRectGetMaxY(lineView.frame)-0.5f;
        CGFloat lineH=kWeatherCellH-lineY-kFunctionCellBottomLineH;
        
        for (int i=1; i<3; i++) {
            UIView *seprateLine=[[UIView alloc] initWithFrame:CGRectMake(width/3.f*i, lineY,1, lineH)];
            seprateLine.backgroundColor=kLineColor;
            [self addSubview:seprateLine];
        }
        //10. 温度
        CGFloat todayTemLabelY=kWeatherCellH-kFunctionCellBottomLineH-20.f-kWeatherPadding;
        todayTempLabel=[[UILabel alloc] initWithFrame:CGRectMake(kPadding, todayTemLabelY, width/3.f-kPadding*2, 20)];
        todayTempLabel.textColor=[UIColor grayColor];
        todayTempLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:todayTempLabel];
        
        //11、风力
        windLabel=[[UILabel alloc] initWithFrame:CGRectMake(kPadding+cardW, todayTemLabelY, width/3.f-kPadding*2, 20)];
        windLabel.textColor=[UIColor grayColor];
        windLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:windLabel];
        //12、 PM2.5

        pm25Label=[[UILabel alloc] initWithFrame:CGRectMake(kPadding+cardW*2, todayTemLabelY, width/3.f-kPadding*2, 20)];
        pm25Label.textColor=[UIColor grayColor];
        pm25Label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:pm25Label];
        
        //13. 添加底部的标示线
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, kWeatherCellH-kFunctionCellBottomLineH, width, kFunctionCellBottomLineH)];
        bottomView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weathercolor"]];
        [self addSubview:bottomView];
        
    }
    return self;
}


/*获得高度*/

+(CGFloat)heightForContentView:(FunctionModel *)model{
    return kWeatherCellH;
}
/*设置数据源*/
-(void)setFunctionModel:(FunctionModel *)model{
    [super setFunctionModel:model];
    
    _weatherModel=model.weatherModel;
    //1.城市
    _cityLabel.text=model.cityName;
    
    //天气描述
    NSString *weatherDes=_weatherModel.todayWeather.weatherDes;
    _todayWeaDesLabel.text=weatherDes;
    
    
//   沙尘暴浮尘|扬沙|强沙尘暴|
    
    if ([weatherDes isEqualToString:@"晴"]) {
        _weatherIcon.image=[UIImage imageNamed:@"retina_sunning"]; //
    }else if ([weatherDes isEqualToString:@"霾"]||[weatherDes isEqualToString:@"雾"]||[weatherDes containsString:@"沙尘暴"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_fog"];
    }else if ([weatherDes isEqualToString:@"多云"]||[weatherDes isEqualToString:@"阴"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_cloud"];
    }else if ([weatherDes isEqualToString:@"小雪转晴"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_snowshower"];
    }else if ([weatherDes isEqualToString:@"多云转晴"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_cloud"];
    }else if ([weatherDes isEqualToString:@"阴转多云"]||[weatherDes isEqualToString:@"多云转阴"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_cloudy"];
    }else if ([weatherDes isEqualToString:@"晴转多云"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_cloudy"];
    }else if ([weatherDes containsString:@"小雨"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_flurry"];
    }else if ([weatherDes containsString:@"暴雨"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_heavy"];
    }else if ([weatherDes containsString:@"中雨"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_middler"];
    }else if ([weatherDes containsString:@"大雨"]){
        _weatherIcon.image=[UIImage imageNamed:@"retina_moderate"];
    }else if ([weatherDes containsString:@"阵雨"]){
         _weatherIcon.image=[UIImage imageNamed:@"retina_tunder"];
    }else if ([weatherDes containsString:@"雪"]){
    _weatherIcon.image=[UIImage imageNamed:@"retina_scouther"];
    }else{
        DLog(@"\n新的天气\n");
    }
    
    
    
    //实时温度
    nowTempLabel.text=_weatherModel.nowTemperature;
    //温度变化
    todayTempLabel.text=_weatherModel.todayWeather.temperature;
    //风力
    windLabel.text=_weatherModel.todayWeather.wind;
    //pm2.5
    pm25Label.text=_weatherModel.pm25;
    //日期
    dateLabel.text=_weatherModel.todayWeather.date;
    
    
}


@end
