//
//  NewsWebController.m
//  NewsDemo
//
//  Created by Lves Li on 15/3/20.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "NewsWebController.h"
#import "MBProgressHUD.h"

@interface NewsWebController ()<UIWebViewDelegate>
{
    MBProgressHUD *hud;
}
@end

@implementation NewsWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    webView.delegate=self;
    [self.view addSubview:webView];
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
}





@end
