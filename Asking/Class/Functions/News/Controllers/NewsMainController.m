//
//  NewsMainController.m
//  NewsDemo
//
//  Created by Lves Li on 15/3/20.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "NewsMainController.h"
#import "NewsCollectionCell.h"
#import "NewsTableController.h"
#import "NewsTools.h"
#import "MBProgressHUD.h"


@interface NewsMainController ()<UICollectionViewDelegateFlowLayout>
{
    NSDictionary *_dataSource;
    MBProgressHUD *hud;
}
@end

@implementation NewsMainController

static NSString * const reuseIdentifier = @"CollectionCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *newsPath=[[NSBundle mainBundle] pathForResource:@"news" ofType:@"plist"];
    NSDictionary *newsDictionary=[NSDictionary dictionaryWithContentsOfFile:newsPath];
    _dataSource=newsDictionary;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *allKeys=_dataSource.allKeys;
    NSString *categary=allKeys[indexPath.row];
    cell.catogaryLabel.text=categary;

    cell.backgroundColor=[self getColorByCategory:categary];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2.f-10, kScreenWidth/2.f-10);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *allKeys=_dataSource.allKeys;
    NSString *categoryStr=allKeys[indexPath.row];
    //显示HUD
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    //请求数据
    [NewsTools requestByCategory:categoryStr newsSuccess:^(NSArray *newsArray) {
        [hud hide:YES];
        NewsTableController *newsListCon=[[NewsTableController alloc] init];
        newsListCon.dataSource=newsArray;
        [self.navigationController pushViewController:newsListCon animated:YES];
        
    } andFailure:^(NSError *error) {
        [hud hide:YES];
    }];
}

-(UIColor *)getColorByCategory:(NSString *)category{
    UIColor *bgColor;
    if ([category isEqualToString:@"互联网"]) {
        bgColor=[UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"体育"]){
        bgColor=[UIColor colorWithRed:25/255.0f green:188/255.0f blue:63/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"军事"]){
        bgColor=[UIColor colorWithRed:221/255.0f green:170/255.0f blue:59/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"国内新闻"]){
        bgColor=[UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"国际新闻"]){
        bgColor=[UIColor colorWithRed:255/255.0f green:95/255.0f blue:154/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"奇闻轶事"]){
        bgColor=[UIColor colorWithRed:105/255.0f green:5/255.0f blue:98/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"新闻要闻"]){
        bgColor=[UIColor colorWithRed:205/255.0f green:128/255.0f blue:185/255.0f alpha:0.9];
    }else if ([category isEqualToString:@"科技"]){
        bgColor=[UIColor colorWithRed:147/255.0f green:112/255.0f blue:205/255.0f alpha:0.9];
    }else{
        bgColor=[UIColor colorWithRed:47/255.0f green:152/255.0f blue:55/255.0f alpha:0.9];
    }

    return bgColor;
}



@end
