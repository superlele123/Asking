//
//  SpeechParseEngine.m
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "SpeechParseEngine.h"
#import "WeatherTools.h"
#import "AppDelegate.h"
#import "DianPingTools.h"
#import "DianPingKeyModel.h"





@implementation SpeechParseEngine

#pragma mark - 解析总接口
-(id)parseSpeechByDictionary:(NSDictionary *)dic{
    id model;
    //Service类型
    NSString *service=dic[@"service"];
    if ([@"map" isEqualToString:service]) { //1. 地图
        model= [self parseMap:dic];
    }else if ([@"weather" isEqualToString:service]){
        model=[self parseWeather:dic];
    }else if ([@"openQA" isEqualToString:service]){  //智能聊天
        model=[self parseOpenQA:dic];
    }else if ([@"music" isEqualToString:service]){
        model=[self parseMusic:dic];
    }else if ([@"restaurant" isEqualToString:service]){
        model=[self parseRestaurant:dic];
    }else if ([@"telephone" isEqualToString:service]){
        model=[self parseTelePhone:dic];
    }else if ([@"news" isEqualToString:service]){
        model=[self parseNews:dic];
    }else{
         model=[self parseDianPing:dic];
    }

    return model;
}

#pragma mark - 具体解析





#pragma mark 智能回答
-(MessageModel *)parseOpenQA:(NSDictionary *)dic{
    NSString *answer=dic[@"answer"][@"text"];
    
    MessageModel *newModel=[[MessageModel alloc] init];
    newModel.type=MessageBodyType_Text;
    newModel.isSender=NO;
    newModel.content=answer;

    return newModel;
}
#pragma mark 新闻
-(FunctionModel *)parseNews:(NSDictionary *)dic{
    FunctionModel *resultModel=[[FunctionModel alloc] init];
    resultModel.type=FunctionTypeNews;
    return resultModel;
}

#pragma mark 打电话
-(FunctionModel *)parseTelePhone:(NSDictionary *)dic{
    NSString *name=dic[@"semantic"][@"slots"][@"name"];
    FunctionModel *resultModel=[[FunctionModel alloc] init];
    resultModel.type=FunctionTypeTelephone;
    
    TelephoneModel *telephoneModel=[[TelephoneModel alloc] init];
    telephoneModel.name=name;
    resultModel.telephoneModel=telephoneModel;
    return resultModel;
    
}


#pragma mark 解析地图
-(FunctionModel *)parseMap:(NSDictionary *)dic{
    //
    NSDictionary *endLoc=dic[@"semantic"][@"slots"][@"endLoc"];
    NSDictionary *startLoc=dic[@"semantic"][@"slots"][@"startLoc"];
    //开始点
    NSString *startPoi=startLoc[@"poi"];
    if ([@"CURRENT_POI" isEqualToString:startPoi]) {
        startPoi=@"当前位置";
    }
    //创建模型
    FunctionModel *mapModel=[[FunctionModel alloc] init];
    mapModel.type=FunctionTypeMap;
    mapModel.startStr=startPoi;
    mapModel.endStr=endLoc[@"poi"];
    return mapModel;
}

#pragma mark 解析天气
-(FunctionModel *)parseWeather:(NSDictionary *)dic{
    
    NSDictionary *location=dic[@"semantic"][@"slots"][@"location"];
    NSString *cityName=location[@"city"];
    
    if ([cityName isEqualToString:@"CURRENT_CITY"]) { //当前城市
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        cityName=appDelegate.cityName;
    }
    FunctionModel *funcModel=[[FunctionModel alloc] init];
    funcModel.type=FunctionTypeWeather;
    funcModel.cityName=cityName;
    return funcModel;
}

#pragma mark - 解析音乐
-(FunctionModel *)parseMusic:(NSDictionary *)dic{
    
    id artist=dic[@"semantic"][@"slots"][@"artist"];
    id song=dic[@"semantic"][@"slots"][@"song"];
    
    
    
    FunctionModel *funcModel=[[FunctionModel alloc] init];
    funcModel.type=FunctionTypeMusic;
    
    MusicModel *musicModel=[[MusicModel alloc] init];
    //1.获得音乐家
    if (artist&&[artist isKindOfClass:[NSString class]]) {
         musicModel.artist=artist;
    }
    //2. 获取歌曲名
    if (song&&[song isKindOfClass:[NSString class]]) {
        musicModel.songName=song;
    }
    //3. 获得语义
    id text=dic[@"text"];
    if (text&&[text isKindOfClass:[NSString class]]) {
        musicModel.text=text;
    }
    
    funcModel.musicModel=musicModel;
    return funcModel;
}
#pragma mark - 解析美食
/*
 {
 operation = QUERY;
 rc = 0;
 semantic =     {
 slots =         {
 category = "\U7f8e\U98df";
 location =             {
 city = "CURRENT_CITY";
 poi = "CURRENT_POI";
 type = "LOC_POI";
 };
 };
 };
 service = restaurant;
 text = "\U9644\U8fd1\U7684\U7f8e\U98df\U3002";
 }
*/
-(FunctionModel *)parseRestaurant:(NSDictionary *)dic{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *location=dic[@"semantic"][@"slots"][@"location"];
    
    //获得区域
    NSString *poi=location[@"poi"];
   
    
    //获得城市
    NSString *cityName=location[@"city"];
    if ([cityName isEqualToString:@"CURRENT_CITY"]) { //当前城市
       
        cityName=appDelegate.cityName;
    }
    //获得分类
    NSString *category=@"";
    NSString *keyword=@"";
    //有分类
    if (dic[@"semantic"][@"slots"][@"category"]) {
        category=dic[@"semantic"][@"slots"][@"category"];
        keyword=category;
    }
    
    //获得关键词
    if (keyword.length<=0) {
        
        if (dic[@"semantic"][@"slots"][@"name"]) {
             keyword=dic[@"semantic"][@"slots"][@"name"];
        }else if(dic[@"semantic"][@"slots"][@"special"]){
             keyword=dic[@"semantic"][@"slots"][@"special"];
        }else{
            keyword=@"";
        }
       
    }
    category=@"美食";
    
    
    
    
    FunctionModel *functionModel=[[FunctionModel alloc] init];
    functionModel.cityName=cityName;
    functionModel.type=FunctionTypeDianPing;
    //点评Model
    DianPingModel *dianPingModel=[[DianPingModel alloc] init];
    dianPingModel.cityName=cityName;
    dianPingModel.category=category;
    dianPingModel.keyword=keyword;
    functionModel.dianPingModel=dianPingModel;
    
    if (![@"CURRENT_POI" isEqualToString:poi]) { //当前区域
        NSString *area=location[@"area"];
        if (area.length>0) {
            dianPingModel.district=location[@"area"];
        }else{
            dianPingModel.district=poi;
        }
        
    }else{
        dianPingModel.coordinate2D=appDelegate.userLocation;
    }
    
    return functionModel;
}
#pragma mark 自己做科大讯飞解析
-(FunctionModel *)parseDianPing:(NSDictionary *)dic{
    
    
    NSString *keyWord=dic[@"text"];
    NSString *category=@"";
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    FunctionModel *functionModel=[[FunctionModel alloc] init];
    functionModel.cityName=appDelegate.cityName;
    functionModel.type=FunctionTypeDianPing;
   
   
    
    if (keyWord!=nil) {
        //通过关键词判断类型
         category=[DianPingTools getCategory:keyWord];
    }
    //默认搜索美食
    if (category==nil||category.length<=0) {
        category=@"美食";
    }
    //获得关键词和地区
    DianPingKeyModel *dianPingKeyModel=[self getKeyWordAndDistrict:keyWord];
    keyWord=dianPingKeyModel.keyWord;
    
    
    
    //点评Model
    DianPingModel *dianPingModel=[[DianPingModel alloc] init];
    //设置地图搜索还是附近搜索
    if (dianPingKeyModel.district!=NULL&&dianPingKeyModel.district.length>=2) {
         dianPingModel.district=dianPingKeyModel.district; //开发区名
         dianPingModel.cityName=appDelegate.cityName;   //城市
    }else{
         dianPingModel.coordinate2D=appDelegate.userLocation;
    }
    
   
   
    dianPingModel.category=category;
    dianPingModel.keyword=keyWord;
    functionModel.dianPingModel=dianPingModel;
    
    return functionModel;
}
#pragma mark 获得地点和关键词
-(DianPingKeyModel *)getKeyWordAndDistrict:(NSString *)text{
    
    DianPingKeyModel *dianping=[[DianPingKeyModel alloc] init];
    
    NSString *district=@""; //地点名
    NSString *keyWord=@"";
    
    
    NSRange range=[text rangeOfString:@"的"];
    if (range.location!=NSNotFound&&range.length>0) { //找到"的"
        //获得的前边的
        if (range.location>=2) {
            district=[text substringToIndex:range.location];
        }
        //去掉附近
        if ([district isContainsString:@"附近"]) {
            district=[district stringByReplacingOccurrencesOfString:@"附近" withString:@""];
        }
        
        //获得的后边的
        if (range.location+range.length<text.length) {
            keyWord=[text substringFromIndex:range.location+range.length];
        }
    }else{
        keyWord=text;
    }
    
    dianping.keyWord=keyWord;
    dianping.district=district;
    return dianping;
    
    
}






@end
