//
//  DianPingListController.m
//  DianPingDemo
//
//  Created by Lves Li on 15/3/3.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "DianPingListController.h"
#import "DianPingTools.h"
#import "DianPingCell.h"
#import "BusinessDetailController.h"



@interface DianPingListController ()
{
    NSArray *_dataSource;
}

@end

@implementation DianPingListController
@synthesize businessArray;

- (void)viewDidLoad {
    [super viewDidLoad];
     _dataSource=businessArray;
    
    
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem=backButtonItem;

    
}


-(void)backButtonClick:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * showUserInfoCellIdentifier = @"DianPingCell";
    DianPingCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        
        cell = [[DianPingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
    }
    
    Business *business=_dataSource[indexPath.row];
    cell.business=business;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Business *business=_dataSource[indexPath.row];
    BusinessDetailController *deatilWebView=[[BusinessDetailController alloc] init];
    deatilWebView.businessUrl=business.business_url;
    [self.navigationController pushViewController:deatilWebView animated:YES];
    
}



@end
