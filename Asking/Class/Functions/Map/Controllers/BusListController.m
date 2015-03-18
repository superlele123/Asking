//
//  BusListController.m
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "BusListController.h"
#import "TimeSecondsToString.h"


@interface BusListController ()

@end

@implementation BusListController
@synthesize transitArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.contentInset=UIEdgeInsetsMake(20, 0, 0, 0);
    
    
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , 40)];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.backgroundColor=[UIColor whiteColor];
    headerLabel.text=[NSString stringWithFormat:@"%@ → %@",self.startPlaceStr,self.endPlaceStr];
    self.tableView.tableHeaderView=headerLabel;
    
   
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];
    view.backgroundColor = [UIColor clearColor];//根据需求改变着个颜色不需要改为clear
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];//根据需求改变着个颜色不需要改为clear
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return transitArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * showUserInfoCellIdentifier = @"BusCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:showUserInfoCellIdentifier];
    }
    
    AMapTransit *transit=transitArray[indexPath.section];  //获得一种交通方案
    //拼接途径路线公交名
    NSMutableString *title=[NSMutableString string];
    NSString *detailTitle=[NSString stringWithFormat:@"花费%@ | 步行%ld米",[TimeSecondsToString secondsToString:transit.duration],(long)transit.walkingDistance];
    for (AMapSegment *segment in transit.segments ) {
        if (segment.busline.name) {
            NSString *busLineName=segment.busline.name;
            NSUInteger loc=[busLineName rangeOfString:@"("].location;
            if (loc>0) {  //有（）
                busLineName=[busLineName substringToIndex:loc];
            }
            
            [title appendFormat:@"%@→",busLineName];
        }
        
    }
    
    
    //去除末尾的箭头
    if ([title hasSuffix:@"→"]) {
        [title replaceCharactersInRange:NSMakeRange(title.length-1, 1) withString:@""];
    }
    
    cell.textLabel.numberOfLines=0;
    cell.textLabel.text=title;
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.detailTextLabel.text=detailTitle;
    
    
    return cell;
    
}

#pragma mark 点击某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(busListControllerClickedCell:)]) {
        [self.delegate busListControllerClickedCell:indexPath.section];
    }
}

@end
