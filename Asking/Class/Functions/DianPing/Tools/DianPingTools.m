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
    [params setObject:dianPingModel.keyword forKey:@"keyword"];
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


+ (NSString *)getCategory:(NSString *)name
{
    if ([name isContainsString:@"加油站"] ||
        [name isContainsString:@"汽车美容"] ||
        [name isContainsString:@"维修保养"] ||
        [name isContainsString:@"4s店"] ||
        [name isContainsString:@"汽车销售"] ||
        [name isContainsString:@"汽车租赁"] ||
        [name isContainsString:@"停车场"] ||
        [name isContainsString:@"汽车配件"] ||
        [name isContainsString:@"车饰"] ||
        [name isContainsString:@"汽车保险"] ||
        [name isContainsString:@"JIAYOUZHAN"] ||
        [name isContainsString:@"QICHEMEIRONG"] ||
        [name isContainsString:@"WEIXIUBAOYANG"] ||
        [name isContainsString:@"SISDIAN"] ||
        [name isContainsString:@"QICHEXIAOSHOU"] ||
        [name isContainsString:@"QICHEZULIN"] ||
        [name isContainsString:@"TINGCHECHANG"] ||
        [name isContainsString:@"QICHEPEIJIAN"] ||
        [name isContainsString:@"CHESHI"] ||
        [name isContainsString:@"QICHEBAOXIAN"])
    {
        return @"爱车";
    }
    else if ([name isContainsString:@"装修设计"] ||
             [name isContainsString:@"建材"] ||
             [name isContainsString:@"家具家居"] ||
             [name isContainsString:@"家装卖场"] ||
             [name isContainsString:@"家用电器"] ||
             [name isContainsString:@"ZHUANGXIUSHEJI"] ||
             [name isContainsString:@"JIANCAI"] ||
             [name isContainsString:@"JIAJUZHUANGXIU"] ||
             [name isContainsString:@"JIAZHUANGMAICHANG"] ||
             [name isContainsString:@"JIAYONGDIANQI"] )
    {
        return @"家装";
    }
    else if ([name isContainsString:@"婚纱摄影"] ||
             [name isContainsString:@"婚宴酒店"] ||
             [name isContainsString:@"婚纱礼服"] ||
             [name isContainsString:@"婚戒首饰"] ||
             [name isContainsString:@"婚庆公司"] ||
             [name isContainsString:@"婚车租赁"] ||
             [name isContainsString:@"彩妆造型"] ||
             [name isContainsString:@"婚礼小礼物"] ||
             [name isContainsString:@"婚礼跟拍"] ||
             [name isContainsString:@"个性写真"] ||
             [name isContainsString:@"司仪主持"] ||
             [name isContainsString:@"婚房装修"] ||
             
             [name isContainsString:@"HUNSHASHEYING"] ||
             [name isContainsString:@"HUNYANJIUDIAN"] ||
             [name isContainsString:@"HUNSHALIFU"] ||
             [name isContainsString:@"HUNJIESHOUSHI"] ||
             [name isContainsString:@"HUNQINGGONGSI"] ||
             [name isContainsString:@"HUNCHEZULIN"] ||
             [name isContainsString:@"CAIZHUANGZAOXING"] ||
             [name isContainsString:@"HUNLIXIAOLIWU"] ||
             [name isContainsString:@"HUNLIGENPAI"] ||
             [name isContainsString:@"GEXINGXIEZHEN"] ||
             [name isContainsString:@"SIYIZHUCHI"] ||
             [name isContainsString:@"HUNFANGZHUANGXIU"])
    {
        return @"结婚";
    }
    else if ([name isContainsString:@"亲子游乐"] ||
             [name isContainsString:@"亲子摄影"] ||
             [name isContainsString:@"幼儿教育"] ||
             [name isContainsString:@"亲子购物"] ||
             [name isContainsString:@"孕妇写真"] ||
             [name isContainsString:@"孕妇护理"] ||
             
             [name isContainsString:@"QINZIYOULE"] ||
             [name isContainsString:@"QINZISHEYING"] ||
             [name isContainsString:@"YOUERJIAOYU"] ||
             [name isContainsString:@"QINZIGOUWU"] ||
             [name isContainsString:@"YUNFUXIEZHEN"] ||
             [name isContainsString:@"YUNFUHULI"] )
    {
        return @"亲子";
    }
    else if ([name isContainsString:@"卡丁车"] ||
             [name isContainsString:@"健身中心"] ||
             [name isContainsString:@"舞蹈"] ||
             [name isContainsString:@"瑜伽"] ||
             [name isContainsString:@"游泳馆"] ||
             [name isContainsString:@"羽毛球"] ||
             [name isContainsString:@"台球"] ||
             [name isContainsString:@"高尔夫场"] ||
             [name isContainsString:@"高尔夫球场"] ||
             [name isContainsString:@"武术场馆"] ||
             [name isContainsString:@"网球"] ||
             [name isContainsString:@"马术场"] ||
             [name isContainsString:@"篮球场"] ||
             [name isContainsString:@"滑雪场"] ||
             [name isContainsString:@"乒乓球馆"] ||
             [name isContainsString:@"保龄球馆"] ||
             [name isContainsString:@"体育场馆"] ||
             [name isContainsString:@"足球场"] ||
             
             [name isContainsString:@"KADINGCHE"] ||
             [name isContainsString:@"JIANSHENZHONGXIN"] ||
             [name isContainsString:@"WUDAO"] ||
             [name isContainsString:@"YUJIA"] ||
             [name isContainsString:@"YOUYONGGUAN"] ||
             [name isContainsString:@"YUMAOQIU"] ||
             [name isContainsString:@"TAIQIU"] ||
             [name isContainsString:@"GAO'ERFUCHANG"] ||
             [name isContainsString:@"GAO'ERFUQIUCHANG"] ||
             [name isContainsString:@"WUSHUCHANGGUAN"] ||
             [name isContainsString:@"WANGQIU"] ||
             [name isContainsString:@"MASHUCHANG"] ||
             [name isContainsString:@"LANQIUCHANG"] ||
             [name isContainsString:@"HUAXUECHANG"] ||
             [name isContainsString:@"PINGPANGQIUGUAN"] ||
             [name isContainsString:@"BAOLINGQIUGUAN"] ||
             [name isContainsString:@"TIYUCHANGGUAN"] ||
             [name isContainsString:@"ZUQIUCHANG"])
    {
        return @"运动健身";
    }
    else if ([name isContainsString:@"美发"] ||
             [name isContainsString:@"舞蹈"] ||
             [name isContainsString:@"瑜伽"] ||
             [name isContainsString:@"美甲"] ||
             [name isContainsString:@"化妆品"] ||
             [name isContainsString:@"美容"] ||
             [name isContainsString:@"整形"] ||
             [name isContainsString:@"美瞳"] ||
             [name isContainsString:@"齿科"] ||
             [name isContainsString:@"个性写真"] ||
             [name isContainsString:@"纹身"] ||
             [name isContainsString:@"产后塑形"] ||
             [name isContainsString:@"瘦身纤体"] ||
             
             [name isContainsString:@"MEIFA"] ||
             [name isContainsString:@"WUDAO"] ||
             [name isContainsString:@"YUJIA"] ||
             [name isContainsString:@"MEIJIA"] ||
             [name isContainsString:@"HUAZHUANGPIN"] ||
             [name isContainsString:@"MEIRONG"] ||
             [name isContainsString:@"ZHENGXING"] ||
             [name isContainsString:@"MEITONG"] ||
             [name isContainsString:@"CHEKE"] ||
             [name isContainsString:@"GEXINGXIEZHEN"] ||
             [name isContainsString:@"WENSHEN"] ||
             [name isContainsString:@"CHANHOUSUXING"] ||
             [name isContainsString:@"SHOUSHENXIANTI"])
    {
        return @"丽人";
    }
    else if ([name isContainsString:@"ktv"] ||
             [name isContainsString:@"KTV"] ||
             [name isContainsString:@"足疗"] ||
             [name isContainsString:@"按摩"] ||
             [name isContainsString:@"温泉"] ||
             [name isContainsString:@"洗浴"] ||
             [name isContainsString:@"景点"] ||
             [name isContainsString:@"郊游"] ||
             [name isContainsString:@"密室"] ||
             [name isContainsString:@"网吧"] ||
             [name isContainsString:@"网咖"] ||
             [name isContainsString:@"diy手工坊"] ||
             [name isContainsString:@"游乐"] ||
             [name isContainsString:@"桌面游戏"] ||
             [name isContainsString:@"真人cs"] ||
             [name isContainsString:@"采摘"] ||
             [name isContainsString:@"农家乐"] ||
             [name isContainsString:@"文化艺术"] ||
             [name isContainsString:@"棋牌室"] ||
             [name isContainsString:@"公园"] ||
             [name isContainsString:@"中医养"] ||
             [name isContainsString:@"理发店"] ||
             
             [name isContainsString:@"ZULIAO"] ||
             [name isContainsString:@"ANMO"] ||
             [name isContainsString:@"WENQUAN"] ||
             [name isContainsString:@"XIYU"] ||
             [name isContainsString:@"JINGDIAN"] ||
             [name isContainsString:@"JIAOYOU"] ||
             [name isContainsString:@"MISHI"] ||
             [name isContainsString:@"WANGBA"] ||
             [name isContainsString:@"WANGKA"] ||
             [name isContainsString:@"diySHOUGONGFANG"] ||
             [name isContainsString:@"YOULE"] ||
             [name isContainsString:@"ZHUOMIANYOUXI"] ||
             [name isContainsString:@"ZHENRENcs"] ||
             [name isContainsString:@"CAIZHAI"] ||
             [name isContainsString:@"NONGJIALE"] ||
             [name isContainsString:@"WENHUAYISHU"] ||
             [name isContainsString:@"QIPAISHI"] ||
             [name isContainsString:@"GONGYUAN"] ||
             [name isContainsString:@"ZHONGYI"] ||
             [name isContainsString:@"LIFADIAN"])
    {
        return @"休闲娱乐";
    }
    else if ([name isContainsString:@"超市"] ||
             [name isContainsString:@"沃尔玛"] ||
             [name isContainsString:@"家乐福"] ||
             [name isContainsString:@"服饰鞋包"] ||
             [name isContainsString:@"便利店"] ||
             [name isContainsString:@"综合商场"] ||
             [name isContainsString:@"花店"] ||
             [name isContainsString:@"化妆品"] ||
             [name isContainsString:@"药店"] ||
             [name isContainsString:@"眼镜店"] ||
             [name isContainsString:@"亲子购物"] ||
             [name isContainsString:@"珠宝饰品"] ||
             [name isContainsString:@"书店"] ||
             [name isContainsString:@"运动户外"] ||
             [name isContainsString:@"数码产品"] ||
             [name isContainsString:@"特色集市"] ||
             [name isContainsString:@"品牌折扣店"] ||
             [name isContainsString:@"家居建材"] ||
             [name isContainsString:@"食品"] ||
             [name isContainsString:@"办公用品"] ||
             [name isContainsString:@"文化用品"] ||
             [name isContainsString:@"京味儿购物"]||
             [name isContainsString:@"茶道"] ||
             
             [name isContainsString:@"CHAOSHI"] ||
             [name isContainsString:@"WO'ERMA"] ||
             [name isContainsString:@"JIALEFU"] ||
             [name isContainsString:@"FUSHIXIEBAO"] ||
             [name isContainsString:@"BIANLIDIAN"] ||
             [name isContainsString:@"ZONGHESHANGCHANG"] ||
             [name isContainsString:@"HUADIAN"] ||
             [name isContainsString:@"HUAZHUANGPIN"] ||
             [name isContainsString:@"YAODIAN"] ||
             [name isContainsString:@"YANJINGDIAN"] ||
             [name isContainsString:@"QINZIGOUWU"] ||
             [name isContainsString:@"ZUBAOSHOUSHI"] ||
             [name isContainsString:@"SHUDIAN"] ||
             [name isContainsString:@"YONGDONGHUWAI"] ||
             [name isContainsString:@"SHUMACHANPIN"] ||
             [name isContainsString:@"RESEJISHI"] ||
             [name isContainsString:@"PINPAIZHEKOUDIAN"] ||
             [name isContainsString:@"JIAJUJIANCAI"] ||
             [name isContainsString:@"SHIPIN"] ||
             [name isContainsString:@"BANGONGYONGPIN"] ||
             [name isContainsString:@"WENHUAYONGPIN"] ||
             [name isContainsString:@"JINGWEI'ERGOUWU"]||
             [name isContainsString:@"CHADAO"])
    {
        return @"购物";
    }
    else if ([name isContainsString:@"银行"] ||
             [name isContainsString:@"理发店"] ||
             [name isContainsString:@"宠物"] ||
             [name isContainsString:@"快照"] ||
             [name isContainsString:@"冲印"] ||
             [name isContainsString:@"医院"] ||
             [name isContainsString:@"洗衣店"] ||
             [name isContainsString:@"家政"] ||
             [name isContainsString:@"电信营业厅"] ||
             
             [name isContainsString:@"培训"] ||
             [name isContainsString:@"齿科"] ||
             [name isContainsString:@"体检中心"] ||
             [name isContainsString:@"售票点"] ||
             [name isContainsString:@"奢侈品护理"] ||
             [name isContainsString:@"旅行社"] ||
             [name isContainsString:@"物流快递"] ||
             [name isContainsString:@"居家维修"] ||
             [name isContainsString:@"学校"] ||
             [name isContainsString:@"房屋地产"] ||
             [name isContainsString:@"小区"] ||
             [name isContainsString:@"交通"] ||
             [name isContainsString:@"公司"]||
             [name isContainsString:@"企业"] ||
             [name isContainsString:@"网站"] ||
             [name isContainsString:@"商务楼"] ||
             
             [name isContainsString:@"YINHANG"] ||
             [name isContainsString:@"LIFADIAN"] ||
             [name isContainsString:@"CHONGWU"] ||
             [name isContainsString:@"KUAIZHAO"] ||
             [name isContainsString:@"CHONGYIN"] ||
             [name isContainsString:@"YIYUAN"] ||
             [name isContainsString:@"XIYIDIAN"] ||
             [name isContainsString:@"JIAZHENG"] ||
             [name isContainsString:@"DIANXINYINGYETING"] ||
             
             [name isContainsString:@"PEIXUN"] ||
             [name isContainsString:@"CHIKE"] ||
             [name isContainsString:@"TIYANZHONGXIN"] ||
             [name isContainsString:@"SHOUPIAODIAN"] ||
             [name isContainsString:@"SHECHIPINHULI"] ||
             [name isContainsString:@"LIXINGSHE"] ||
             [name isContainsString:@"WULIUKUAIDI"] ||
             [name isContainsString:@"JUJIAWEIXIU"] ||
             [name isContainsString:@"XUEXIAO"] ||
             [name isContainsString:@"FANGDICHAN"] ||
             [name isContainsString:@"XIAOQU"] ||
             [name isContainsString:@"JIAOTONG"] ||
             [name isContainsString:@"GONGSI"]||
             [name isContainsString:@"QIYE"] ||
             [name isContainsString:@"WANGZHAN"] ||
             [name isContainsString:@"SHANGWULOU"])
    {
        return @"生活服务";
    }
    else if ([name isContainsString:@"电影院"] ||
             [name isContainsString:@"私人影院"] ||
             
             [name isContainsString:@"DIANYINGYUAN"] ||
             [name isContainsString:@"SIRENYINGYUAN"])
    {
        return @"电影";
    }else{
        return @"美食";
    }
    return nil;
}


@end
