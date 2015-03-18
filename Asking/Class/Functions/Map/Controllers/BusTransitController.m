//
//  BusTransitController.m
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "BusTransitController.h"
#import "BusTransitCell.h"

@interface BusTransitController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTableView;
    ///数据源
    NSArray *_dataSourceArray;
    ///是否显示详情控制
    NSMutableArray *showMoreArray;
    
}

@end

@implementation BusTransitController
@synthesize busTransit;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    //初始化是否显示详情按钮
    showMoreArray=[NSMutableArray array];
    for (int i=0;i<_dataSourceArray.count;i++) {
        [showMoreArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    
    [self buildTableView];
   
}

-(void)buildTableView{
    _mainTableView=[[UITableView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, 10)];
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    _mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置起点和终点
-(void)setStartPlace:(NSString *)start andEndPlace:(NSString *)endPlace{
    //添加起点和终点
    AMapSegment *startSegment=[[AMapSegment alloc] init];
    startSegment.enterName=@"起点";
    startSegment.exitName=start;
    
    AMapSegment *endSegment=[[AMapSegment alloc] init];
    endSegment.enterName=@"终点";
    endSegment.exitName=endPlace;
    
    NSMutableArray *segmentsArray=[busTransit.segments mutableCopy];
    [segmentsArray insertObject:startSegment atIndex:0];
    [segmentsArray addObject:endSegment];
    
    //设置数据源
    _dataSourceArray=segmentsArray;
    
}


#pragma mark - MainTableView 代理和数据源

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapSegment *segement=_dataSourceArray[indexPath.row];
    //BOOL ifShow=[showMoreArray[indexPath.row] boolValue];
    return [BusTransitCell heightOfTransitCellWithSegment:segement andIfShowMore:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * showUserInfoCellIdentifier = @"BusTransitCell";
    BusTransitCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        cell = [[BusTransitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    }
    
//    cell.moreBtn.tag=indexPath.row;
    //公交换乘路段
    AMapSegment *segement=_dataSourceArray[indexPath.row];
    BOOL isEnd=NO;
    if (indexPath.row==_dataSourceArray.count-1) {
        isEnd=YES;
    }
    
    //BOOL ifShow=[showMoreArray[indexPath.row] boolValue];
    
    
    [cell setSegment:segement andIndex:indexPath.row andIsEnd:isEnd andIfShowMore:YES];
    //[cell.moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    
//    
//    AMapSegment *segement=_dataSourceArray[indexPath.row];
//    if (segement.walking) {
//        //更改数据源
//        BOOL ifShow=[showMoreArray[indexPath.row] boolValue];
//        [showMoreArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!ifShow]];
//        //局部刷新
//        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//    
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BusTransitCell *cell=(BusTransitCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.backgroundView.backgroundColor=[UIColor clearColor];
    
}

//#pragma mark 点击cell 详情按钮
//-(void)clickMoreBtn:(UIButton *)sender{
//    
//    
//    
//    
//    NSUInteger index=sender.tag;
//    NSIndexPath *path=[NSIndexPath indexPathForRow:index inSection:0];
//    //更改数据源
//    BOOL ifShow=[showMoreArray[index] boolValue];
//    [showMoreArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!ifShow]];
//    
//    
//    //局部刷新
//    [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationFade];
//    
//}
//



@end


























