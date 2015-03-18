//
//  DianPingTools.m
//  DianPingDemo
//
//  Created by Lves Li on 15/3/3.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "DianPingTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "Business.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "DianPingModel.h"


#define kDianPingAppKey             @"2092073324"
#define kDianPinAppSecret          @"6a874042cbd74759818767208a4faa27"

//#define kDianPinAppKey             @"58058872"
//#define kDianPinAppSecret          @"f1d20b3b8b954b9f98833167ecebc720"


/*
 结果排序，1:默认，2:星级高优先，3:产品评价高优先，4:环境评价高优先，5:服务评价高优先，6:点评数量多优先，7:离传入经纬度坐标距离近优先，8:人均价格低优先，9：人均价格高优先
 */

@implementation DianPingTools

+(void)requestDianpingBy:(DianPingModel *)dianPingModel andPage:(int)page success:(DianPingSuccessBlock)successBlock andFailure:(DianPingFailureBlock)failureBlock{

    //1. 获得参数列表
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    if (dianPingModel.coordinate2D.longitude!=0&&dianPingModel.coordinate2D.latitude!=0) {
        [params setObject:[NSString stringWithFormat:@"%f",dianPingModel.coordinate2D.latitude]  forKey:@"latitude"];
        [params setObject:[NSString stringWithFormat:@"%f",dianPingModel.coordinate2D.longitude] forKey:@"longitude"];
        [params setObject:@"7" forKey:@"sort"]; //距离优先
    }
    
    if (dianPingModel.district.length>0) {
        NSString *cityName=dianPingModel.cityName;
        cityName=[cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        [params setObject:cityName forKey:@"city"];
        [params setObject:dianPingModel.district forKey:@"region"];
        [params setObject:@"2" forKey:@"sort"]; //星级高优先
    }
    
    
    [params setObject:dianPingModel.category forKey:@"category"];
    [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    
    [params setObject:@"10" forKey:@"limit"];
    //2. 获得签名
    NSString *paramsUrl=[self getParamsUrlStringByParams:params];
    
    //3.拼接URL
    NSString *urlStr=[NSString stringWithFormat:@"http://api.dianping.com/v1/business/find_businesses?%@",paramsUrl];
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //4.请求
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *businesses=responseObject[@"businesses"];
        NSMutableArray *resultBuiness=[NSMutableArray array];
        for (NSDictionary *businessDic in businesses) {
            Business *business=[[Business alloc] initWithDic:businessDic];
            [resultBuiness addObject:business];
        }
        if (resultBuiness.count>0) {
            if (successBlock) {
                successBlock(resultBuiness);
            }
        }else{
            if (failureBlock) {
                failureBlock(nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

/*
 签名算法如下：
 1. 对除appkey以外的所有请求参数进行字典升序排列；
 2. 将以上排序后的参数表进行字符串连接，如key1value1key2value2key3value3...keyNvalueN；
 3. 将app key作为前缀，将app secret作为后缀，对该字符串进行SHA-1计算，并转换成16进制编码；
 4. 转换为全大写形式后即获得签名串
 */
#pragma mark 获得参数URL
+(NSString *)getParamsUrlStringByParams:(NSDictionary *)params{
    
    NSString *finalSign;
    NSString *paramsString=[NSString stringWithFormat:@"appkey=%@",kDianPingAppKey];
    
    //1.字典名排序
    NSArray *keys= [params allKeys];
    keys=[keys  sortedArrayUsingSelector: @selector(compare:)];
    //2.连接字符串
    NSMutableString *keyLines=[NSMutableString string];
    for (NSString *key in keys) {
        [keyLines appendFormat:@"%@%@",key,params[key]];
        paramsString=[paramsString stringByAppendingFormat:@"&%@=%@",key,params[key]];
    }
    
    NSString *finalString=[NSString stringWithFormat:@"%@%@%@",kDianPingAppKey,keyLines,kDianPinAppSecret];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [finalString dataUsingEncoding: NSUTF8StringEncoding];
    
    if (CC_SHA1([stringBytes bytes], (unsigned int)[stringBytes length], digest)) {
        //3.1 SHA-1计算
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            //3.2 16进制编码
            [digestString appendFormat:@"%02X", aChar];
        }
        //4. 转换为全大写形式
        finalSign=[digestString uppercaseString];
        //5.拼接参数字符串
        paramsString=[paramsString stringByAppendingFormat:@"&sign=%@",finalSign];
        
    }
    return paramsString;
}

@end
