//
//  NaviDetailCell.m
//  高德地图
//
//  Created by Lves Li on 14/12/31.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "NaviDetailCell.h"
#define kTitleFont [UIFont systemFontOfSize:17]
#define kCellPadding 13.f
#define kImageViewW 27.f
#define kPadding 10.f

#define kNaviDetailLabelW kScreenWidth-2*kCellPadding-kImageViewW-2*kPadding-kPadding

@interface NaviDetailCell ()
{
    ///动作指引ImageView
    UIImageView *_actionImageView;
    
    ///Step详情
    UILabel *_stepTitleLabel;
    
    CGFloat labelWidth;
}

@end

@implementation NaviDetailCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置指引图片
        _actionImageView =[[UIImageView alloc] init];
        [self addSubview:_actionImageView];
        
        _stepTitleLabel=[[UILabel alloc] init];
        _stepTitleLabel.numberOfLines=0;
        [self addSubview:_stepTitleLabel];
        
    }
    return self;
}

/*
 设置内容
 */
-(void)setImageViewWithAction:(NSString *)action andSetpInstruction:(NSString *)instruction{
    
    //获得指示的高度
    CGRect frame = [instruction boundingRectWithSize:CGSizeMake(kNaviDetailLabelW, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:kTitleFont}
                                      context:nil];
    
    _stepTitleLabel.text=instruction;
    _stepTitleLabel.frame=CGRectMake(kImageViewW+2*kCellPadding, kCellPadding, kNaviDetailLabelW, frame.size.height);
    
    //添加图片
    _actionImageView.center=CGPointMake(kCellPadding+kImageViewW/2.f, [NaviDetailCell heightOfCellWithStepInstruction:instruction]/2.f);
    _actionImageView.bounds=CGRectMake(0, 0, kImageViewW, kImageViewW);
    
    NSString *imageName;
    
    
   
    
    if ([@"左转" isEqualToString:action]) {
        imageName=@"map_route_turn_left";
    }else if ([@"右转" isEqualToString:action]) {
        imageName=@"map_route_turn_right";
    }else if ([@"往前走" isEqualToString:action]) {
        imageName=@"map_route_turn_front";
    }else if ([@"往后走" isEqualToString:action]) {   //////
        imageName=@"map_route_turn_back";
    }else if ([action hasPrefix:@"向左前方"]) {
        imageName=@"map_route_turn_left_front";
    }else if ([action hasPrefix:@"向右前方"]) {
        imageName=@"map_route_turn_right_front";
    }else if ([action hasPrefix:@"左转调头"]||[action hasPrefix:@"向左后方"]) {
        imageName=@"map_route_turn_left_back";
    }else if ([action hasPrefix:@"右转调头"]||[action hasPrefix:@"向右后方"]) {
        imageName=@"map_route_turn_right_back";
    }else if ([action hasPrefix:@"靠左"]) {
        imageName=@"map_route_turn_left_side";
    }else if ([action hasPrefix:@"靠右"]) {
        imageName=@"map_route_turn_right_side";
    }else if ([@"直行" isEqualToString:action]) {
        imageName=@"map_route_turn_front";
    }else if ([@"减速行驶" isEqualToString:action]) {
        imageName=@"map_route_turn_front";
    }else if (action.length==0){
        imageName=@"map_route_turn_undefine";
       
    }
    ///自定义的两个点
    else if ([@"起点" isEqualToString:action]){
        imageName=@"icon_route_st";
        _actionImageView.bounds=CGRectMake(0, 0, 12, 12);
    }
    else if ([@"终点" isEqualToString:action]){
        imageName=@"icon_route_end";
        _actionImageView.bounds=CGRectMake(0, 0, 12, 12);
    }else{
         DLog(@"Action:::::::%@\n",action);
    }
    
    _actionImageView.image=[UIImage imageNamed:imageName];
    
    
    
}

/*
获得高度
*/
+(CGFloat)heightOfCellWithStepInstruction:(NSString *)instruction{
    CGRect frame = [instruction boundingRectWithSize:CGSizeMake(kNaviDetailLabelW, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:kTitleFont}
                                             context:nil];
    
    CGFloat height=frame.size.height+2*kCellPadding;
    if (height<kImageViewW+2*kCellPadding) {
        height=kImageViewW+2*kCellPadding;
    }
    
    return height;
}


#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x += kPadding;
    frame.size.width -= 2 * kPadding;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
