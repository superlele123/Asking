//
//  FunctionModel.h
//  Asking
//
//  Created by Lves Li on 14/11/14.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"
#import "MusicModel.h"
#import "DianPingModel.h"
#import "TelephoneModel.h"


/*!
 @enum
 @brief 功能类型
 @constant eMessageBodyType_Text 文本类型

 */
typedef enum {
    FunctionTypeWeather,
    FunctionTypeMap,
    FunctionTypeDianPing,
    FunctionTypeMusic,
    FunctionModelTelephone///电话
}FunctionType;


@interface FunctionModel : NSObject
///数据类型
@property (nonatomic,assign) FunctionType type;


#pragma mark 地图

///起始地点名
@property (nonatomic,copy) NSString *startStr;
///结束地点名
@property (nonatomic,copy) NSString *endStr;


#pragma mark 天气
///城市名
@property (nonatomic,copy)NSString *cityName;

//天气model
@property  (nonatomic,strong)WeatherModel *weatherModel;

#pragma mark 音乐
@property  (nonatomic,strong) MusicModel *musicModel;
#pragma mark 大众点评
@property (nonatomic,strong) DianPingModel *dianPingModel;


#pragma mark  电话
@property (nonatomic,strong)TelephoneModel *telephoneModel;

@end





