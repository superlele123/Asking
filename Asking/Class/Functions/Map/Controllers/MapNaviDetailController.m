//
//  MapNaviDetailController.m
//  高德地图
//
//  Created by Lves Li on 14/12/29.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "MapNaviDetailController.h"
#import "NaviDetailCell.h"


@interface MapNaviDetailController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ///交通方案详情TableView
    UITableView *_tableView;
    NSMutableArray *_dataSourceArray;
    
}

@end

@implementation MapNaviDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //设置右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
  
    [self buildTableView];
    
    
}

-(void)buildTableView{
    //初始化数据源
    _dataSourceArray=[NSMutableArray array];
    
    if (self.mapPath) {
        _dataSourceArray=[self.mapPath.steps mutableCopy];
        
        //添加起始点
        AMapStep *startStep=[[AMapStep alloc] init];
        startStep.action=@"起点";
        startStep.instruction=self.startPlace;
        [_dataSourceArray insertObject:startStep atIndex:0];
        
        //添加终点
        AMapStep *endStep=[[AMapStep alloc] init];
        endStep.action=@"终点";
        endStep.instruction=self.endPlace;
        [_dataSourceArray addObject:endStep];

        
        
    }else if (self.mapTransit){
    
    }
    
  
    
    //创建
    _tableView=[[UITableView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, 5) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f];
    _tableView.backgroundView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
}






#pragma mark - tableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * showUserInfoCellIdentifier = @"NaviDetailCell";
    NaviDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        cell = [[NaviDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
        cell.userInteractionEnabled=NO;
    }
    AMapStep *step=_dataSourceArray[indexPath.row];
    //设置图片和指引
    [cell setImageViewWithAction:step.action andSetpInstruction:step.instruction];
    
    return cell;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapStep *step=_dataSourceArray[indexPath.row];
    //获得高度
    return [NaviDetailCell heightOfCellWithStepInstruction:step.instruction];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end














