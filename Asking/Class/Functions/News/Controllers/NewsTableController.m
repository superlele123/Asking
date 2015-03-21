//
//  NewsTableController.m
//  NewsDemo
//
//  Created by Lves Li on 15/3/19.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "NewsTableController.h"
#import "NewsWebController.h"
#import "News.h"

@interface NewsTableController ()
{
    
    
}

@end

@implementation NewsTableController
@synthesize dataSource=_dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * showUserInfoCellIdentifier = @"NewsCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:showUserInfoCellIdentifier];
    }
    News *news=_dataSource[indexPath.row];
    
    //格林尼治时间转换为本地时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date= [dateFormatter dateFromString:news.pubDate];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];

    NSString *localDateString= [dateFormatter stringFromDate:date];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@发布",localDateString];


    cell.textLabel.text=news.title;
    cell.textLabel.numberOfLines=0;
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    News *news=_dataSource[indexPath.row];
        
    NewsWebController *webView=[[NewsWebController alloc] init];
    webView.urlString=news.link;
    [self.navigationController pushViewController:webView animated:YES];
}


@end
