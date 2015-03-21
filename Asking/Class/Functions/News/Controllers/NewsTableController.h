//
//  NewsTableController.h
//  NewsDemo
//
//  Created by Lves Li on 15/3/19.
//  Copyright (c) 2015年 Lves. All rights reserved.
//  新闻列表页面

#import <UIKit/UIKit.h>


@interface NewsTableController : UITableViewController

///数据源
@property (nonatomic,strong) NSArray *dataSource;
@end
