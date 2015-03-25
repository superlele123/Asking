//
//  NewsTools.m
//  NewsDemo
//
//  Created by Lves Li on 15/3/6.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "NewsTools.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"








@implementation NewsTools

+(void)requestByCategory:(NSString *)newsCategory newsSuccess:(NewsSuccessBlock)success andFailure:(NewsFailureBlock)failure{
    
    
    NSString *newsPath=[[NSBundle mainBundle] pathForResource:@"news" ofType:@"plist"];
    NSDictionary *newsDictionary=[NSDictionary dictionaryWithContentsOfFile:newsPath];
    
    NSString *urlStr=newsDictionary[newsCategory];
    
    
    
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responsStr=[NSString stringWithUTF8String:[responseObject bytes]];
        
        NSArray *newsArray=[self parseSinaNews:responsStr];
        DLog(@"%@",newsArray);
        if(newsArray.count>0&&success){
            success(newsArray);
        }else{
            if (failure) {
                failure([NSError errorWithDomain:@"未请求到新闻" code:10001 userInfo:nil]);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

+(NSArray *)parseSinaNews:(NSString *)responsStr{
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:responsStr options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [xmlEle children];
    
    
    NSMutableArray *newsResultArray=[NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        // 根据标签名判断
        if ([[ele name] isEqualToString:@"channel"]) {  //标题
            NSArray *childrenEle=[ele children];
            
            for (GDataXMLElement *childEle in childrenEle) {
                if ([[childEle name] isEqualToString:@"item"]) {
                     //获得具体的新闻Element
                     NSArray *newsEle=[childEle children];
                    //遍历新闻item获得详细内容
                    News *news=[[News alloc] init];
                    for (GDataXMLElement *newsItem in newsEle) {
                       
                        NSString *elementName=[newsItem name];
                        NSString *value=[newsItem stringValue];
                        if ([elementName isEqualToString:kNewsTitle]) {
                            news.title=value;
                        }else if ([elementName isEqualToString:kNewsAuthor]){
                            news.author=value;
                        }else if ([elementName isEqualToString:kNewsPubDate]){
                            news.pubDate=value;
                        }else if ([elementName isEqualToString:kNewsCategory]){
                            news.category=value;
                        }else if ([elementName isEqualToString:kNewsDescription]){
                            news.summary=value;
                        }else if ([elementName isEqualToString:kNewsGuid]){
                            news.guid=value;
                        }else if ([elementName isEqualToString:kNewsLink]){
                            news.link=value;
                        }
                    }
                    //添加到数组
                    [newsResultArray addObject:news];
                }
            }
            
        }
        
    }

    return newsResultArray;

}


@end
