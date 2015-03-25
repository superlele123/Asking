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
    
    self.title=@"商户详情";
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.businessUrl]]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    //设置按钮字体
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"返回"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(backButtonClick:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    
}

-(void)backButtonClick:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
