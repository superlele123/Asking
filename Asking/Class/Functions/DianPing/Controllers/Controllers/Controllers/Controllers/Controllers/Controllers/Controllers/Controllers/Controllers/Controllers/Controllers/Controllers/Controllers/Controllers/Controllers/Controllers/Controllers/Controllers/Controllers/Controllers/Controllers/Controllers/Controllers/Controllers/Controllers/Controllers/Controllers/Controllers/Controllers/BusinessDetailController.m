//
//  BusinessDetailController.m
//  DianPingDemo
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "BusinessDetailController.h"

@interface BusinessDetailController ()

@end

@implementation BusinessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.businessUrl]]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
