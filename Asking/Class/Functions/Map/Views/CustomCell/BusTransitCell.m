//
//  BusStepsCell.m
//  高德地图
//
//  Created by Lves Li on 15/1/2.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "BusTransitCell.h"

#define  kLineBlackColor [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1]
#define  kSeperatorLineH 0.7f
#define  kLeftScale 0.2f
#define  kPadding 10.f

#define  kTitleH 23.f
#define  kTypeIconW 20.f



@interface BusTransitCell ()
{
    ///换乘类型图标
    UIImageView *iconImageView;
    ///转乘标题
    UILabel *segmentTitleLabel;
    ///公交换乘路段
    AMapSegment *_segment;
    ///左边的竖线
    UIView *leftLine;
    ///底部的线
    UIView  *seperatorLine;
    
    //详情WebView
    UIWebView *detailWebView;
    NSString *detail;
    
    
    ///cell在tableView中得indexPath
    NSInteger cellIndex;
    
}
@end

@implementation BusTransitCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
        //1. 添加竖线
        leftLine=[[UIView alloc] init];
        leftLine.backgroundColor=kLineBlackColor;
        [self addSubview:leftLine];
        //2. 添加交通Icon
        iconImageView=[[UIImageView alloc] init];
        
        iconImageView.bounds=CGRectMake(0, 0, kTypeIconW,kTypeIconW);
        [self addSubview:iconImageView];
        
        //3. 添加Titile
        segmentTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*kLeftScale+kPadding, kPadding,kScreenWidth*(1-kLeftScale)-2*kPadding, kTitleH)];
        [self addSubview:segmentTitleLabel];
        
        
        //4.添加详情WebView
        detailWebView=[[UIWebView alloc] init];
        detailWebView.scrollView.scrollEnabled=NO;
        [self addSubview:detailWebView];
        
        
        //添加底部的分割线
        seperatorLine=[[UIView alloc] init];
        seperatorLine.backgroundColor=kLineBlackColor;
        [self addSubview:seperatorLine];
        
        
    }
    return  self;
    
}



/*
 设置公交路段和路段下标
 */
-(void)setSegment:(AMapSegment *)segment andIndex:(NSInteger)index andIsEnd:(BOOL)isEnd andIfShowMore:(BOOL)ifShowMore{
    _segment=segment;
    cellIndex=index;
    
    CGFloat height=[BusTransitCell heightOfTransitCellWithSegment:segment andIfShowMore:ifShowMore];
    
    
    
    
    //1. 设置左边的Icon
    NSString *imageName;
    AMapBusLine *busline=segment.busline;
    AMapWalking *walking=segment.walking;
    
    if (busline) {  //公交换乘
        
        
        
//        [moreBtn removeFromSuperview];
        //1.0 设置图标
        NSString *type=busline.type;
        if([type isEqualToString:@"普通公交线路"]){
            imageName=@"default_path_pathinfo_bus_normal";
        }else if([type isEqualToString:@"地铁线路"]){
            imageName=@"default_path_pathinfo_sub_normal";
        }
        //1.1 换乘标题
        segmentTitleLabel.text=busline.name;
        [detailWebView removeFromSuperview];
        detailWebView=[[UIWebView alloc] init];
        detailWebView.scrollView.scrollEnabled=NO;
        [self addSubview:detailWebView];

        CGFloat webViewX=segmentTitleLabel.frame.origin.x;
        CGFloat webViewY=CGRectGetMaxY(segmentTitleLabel.frame);
        CGFloat webViewW=segmentTitleLabel.frame.size.width;
        detailWebView.frame=CGRectMake(webViewX, webViewY, webViewW, height-2*kPadding-kTitleH);
        //1.2 获得上下站名字
        NSString *turnOnStr,*turnOffStr;
        if (segment.enterName) {
            turnOnStr=[NSString stringWithFormat:@"%@  %@ 上车",busline.departureStop.name,segment.enterName];
        }else{
            turnOnStr=[NSString stringWithFormat:@"%@ 上车",busline.departureStop.name];
        }
        
        if (segment.exitName) {
            turnOffStr=[NSString stringWithFormat:@"%@  %@ 下车",busline.arrivalStop.name,segment.exitName];
        }else{
            turnOffStr=[NSString stringWithFormat:@"%@ 下车",busline.arrivalStop.name];
        }
        
        
        detail=[NSString stringWithFormat:@"<font size=-1 color=gray style=\"line-height:20px;\">%@</br>%@</font>",turnOnStr,turnOffStr];
        
        [detailWebView loadHTMLString:detail baseURL:nil];
        
        
        
    }else if (walking){  //步行换乘
        imageName=@"default_path_pathinfo_foot_normal";
        
        //2.1 换乘标题
        segmentTitleLabel.text=[NSString stringWithFormat:@"步行%.2f公里",segment.walking.distance/1000.f];
        
        

        
        if (ifShowMore) {  //显示详情
            CGFloat webViewX=segmentTitleLabel.frame.origin.x;
            CGFloat webViewY=CGRectGetMaxY(segmentTitleLabel.frame);
            CGFloat webViewW=segmentTitleLabel.frame.size.width;
            
            detailWebView=[[UIWebView alloc] init];
            detailWebView.scrollView.scrollEnabled=NO;
            [self addSubview:detailWebView];
            
            detailWebView.frame=CGRectMake(webViewX, webViewY, webViewW, height-2*kPadding-kTitleH);
            
            NSString *htmlStr=@"";
            NSArray *steps=walking.steps;
            for (int i=0;i<steps.count ;i++) {
                AMapStep *step=steps[i];
                if(i==steps.count-1){
                    htmlStr =[NSString stringWithFormat:@"%@%@",htmlStr,step.instruction];
                }else{
                    htmlStr =[NSString stringWithFormat:@"%@%@</br>",htmlStr,step.instruction];
                }
                
            }
            
            NSString *stepStr=[NSString stringWithFormat:@"<font size=-1 color=gray style=\"line-height:22px;\">%@</font>",htmlStr];
            
            [detailWebView loadHTMLString:stepStr baseURL:nil];
        }else{
            [detailWebView removeFromSuperview];
        }
        
        
    }else{   //起点和终点
        
        [detailWebView removeFromSuperview];
        if(0==index){
            imageName=@"icon_route_st";
            //2.1 换乘标题
            segmentTitleLabel.text=[NSString stringWithFormat:@"起点 (%@)",segment.exitName];
        
        }else if (isEnd){
            imageName=@"icon_route_end";
            //2.1 换乘标题
            segmentTitleLabel.text=[NSString stringWithFormat:@"终点 (%@)",segment.exitName];
        }
    
    }
    
    iconImageView.center=CGPointMake(kScreenWidth*kLeftScale*0.5f, height/2.f);
    iconImageView.image=[UIImage imageNamed:imageName];
    
    //2. 设置左边线的高度
    leftLine.frame=CGRectMake(kScreenWidth*kLeftScale*0.5f-1, 0, 2,height);
    if(isEnd){  //终点cell
        leftLine.frame=CGRectMake(kScreenWidth*kLeftScale*0.5f-1, 0, 2,height/2.f-kTypeIconW/2.f);
    
    }else{
        if (index==0) {  //起点cell
            leftLine.frame=CGRectMake(kScreenWidth*kLeftScale*0.5f-1, height/2.f+kTypeIconW/2.f, 2,height/2.f-kTypeIconW/2.f);
        }
    }
    
    //5. 设置底部的线
  
    seperatorLine.frame=CGRectMake(kScreenWidth*kLeftScale, height-kSeperatorLineH, kScreenWidth*(1-kLeftScale), kSeperatorLineH);
    
    
    

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightOfTransitCellWithSegment:(AMapSegment *)segment andIfShowMore:(BOOL)ifShowMore{
    CGFloat height=0.f;
     if(segment.busline){ //公交
        height=2*kPadding+kTitleH*3;
     }else if (segment.walking) {  //步行
         height=2*kPadding+kTitleH;
     }else{  //起点和终点
         height=2*kPadding+kTitleH;
     }
    
    
    
    if (segment.busline) {
        
    }else if (segment.walking){
        if (ifShowMore) {
            height+=kTitleH*segment.walking.steps.count;
        }
    }
    
    return height;
}


@end
