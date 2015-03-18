//
//  DianPingView.m
//  DianPingDemo
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "DianPingView.h"

@implementation DianPingView

-(void)setBusiness:(Business *)business{
    _business=business;
    self.nameLable.text=business.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:business.s_photo_url] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    self.addressLabel.text=business.address;
    [self.ratingImageView sd_setImageWithURL:[NSURL URLWithString:business.rating_s_img_url] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    self.priceLabel.text=[NSString stringWithFormat:@"%d元/人",business.avg_price];
    //距离
    NSString *distanceString=@"";
    if (business.distance>1000) {
        distanceString=[NSString stringWithFormat:@"%.2f公里",business.distance/1000.f];
    }else{
        distanceString=[NSString stringWithFormat:@"%dm",business.distance];
    }
    self.distanceLabel.text=distanceString;
    
}

@end
