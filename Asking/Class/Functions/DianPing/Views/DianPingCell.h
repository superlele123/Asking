//
//  DianPingCell.h
//  Asking
//
//  Created by Lves Li on 15/3/7.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
@interface DianPingCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (nonatomic,strong) Business *business;
@end
