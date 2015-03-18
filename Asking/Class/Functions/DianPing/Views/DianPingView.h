//
//  DianPingView.h
//  DianPingDemo
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface DianPingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong) Business *business;
@end
