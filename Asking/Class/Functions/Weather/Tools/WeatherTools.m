//
//  WeatherTools.m
//  Asking
//
//  Created by Lves Li on 14/12/3.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "WeatherTools.h"
#import "FunctionModel.h"

@implementation WeatherTools


+(void)getWeatherByCityName:(NSString *)cityName andSuccess:(WeatherSuccessBlock)weatherSuccess andFialure:(WeatherFaildBlock)weatherFaild{
    //参数
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       cityName,@"location",
                       @"json",@"output",
                       @"GQWK952VGq2jfWBoLg3nQmuC",@"ak",
                       @"com.wildcat.asking",@"mcode",
                       nil];
    //结果Model
    __block WeatherModel *weatherModel=nil;
   // NSString *params=[NSString stringWithFormat:@"location=%@&output=%@&ak=%@&mcode=%@",cityName,@"json",@"GQWK952VGq2jfWBoLg3nQmuC",@"com.wildcat.asking"];
    
    //请求管理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.map.baidu.com/telematics/v3/weather" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        weatherModel=[self getWeatherModel:responseObject];
        
        if (weatherSuccess) {
            weatherSuccess(weatherModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
}

//解析获得天气模型
+(WeatherModel *)getWeatherModel:(NSDictionary *)dic{
    WeatherModel *weather;
    NSString *status= dic[@"status"];
    
//    NSLog(@"JSON: %@", dic);
    
    //获得天气成功
    if ([@"success" isEqualToString:status]) {
        weather=[[WeatherModel alloc] init];
        weather.date=dic[@"date"];
        weather.pm25=dic[@"results"][0][@"pm25"];
        
        //四天的天气
        NSArray *weatherArray=dic[@"results"][0][@"weather_data"];
        NSDictionary *today=weatherArray[0];
        NSDictionary *firstDay=weatherArray[1];
        NSDictionary *secondDay=weatherArray[2];
        NSDictionary *thirdDay=weatherArray[3];
        //今天的日期和实时温度
        NSString *todayDateStrs=today[@"date"];
        
        NSString *todayDate;
        NSString *nowTemStr;
        
        NSRange temRange=[todayDateStrs rangeOfString:@"("];
        if (temRange.location!=NSNotFound&&temRange.length>0) {
            //日期
            todayDate=[todayDateStrs substringToIndex:temRange.location-1];
            //实时温度
            nowTemStr=[todayDateStrs substringWithRange:NSMakeRange(temRange.location+4, todayDateStrs.length-(temRange.location+4)-1)];
            
        }
       
        weather.nowTemperature=nowTemStr;
        
        weather.todayWeather=[WeatherDesc  weatherDescWithDate:todayDate description:today[@"weather"] wind:today[@"wind"] andTemperature:today[@"temperature"]];
        weather.firstDayWeather=[WeatherDesc  weatherDescWithDate:firstDay[@"date"] description:firstDay[@"weather"] wind:firstDay[@"wind"] andTemperature:firstDay[@"temperature"]];
        weather.secondDayWeather=[WeatherDesc  weatherDescWithDate:secondDay[@"date"] description:secondDay[@"weather"] wind:secondDay[@"wind"] andTemperature:secondDay[@"temperature"]];
        weather.thirdDayWeather=[WeatherDesc  weatherDescWithDate:thirdDay[@"date"] description:thirdDay[@"weather"] wind:thirdDay[@"wind"] andTemperature:thirdDay[@"temperature"]];
        
    }
    return weather;
}





@end
