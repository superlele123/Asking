//
//  Business.m
//  DianPingDemo
//
//  Created by Lves Li on 15/3/4.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "Business.h"
#import "DianPingDeal.h"

@implementation Business


/*


 ///所在区域信息列表
 @property (nonatomic,strong) NSArray *regions;

 ///团购列表
 @property (nonatomic,strong) NSArray *deals;

 
 */

-(id)initWithDic:(NSDictionary *)dic{
    if (self=[super init]) {
        self.avg_rating=[dic[@"avg_rating"] floatValue];
        self.rating_s_img_url=dic[@"rating_s_img_url"];
        self.rating_img_url=dic[@"rating_img_url"];
        self.city=dic[@"city"];
        self.telephone=dic[@"telephone"];
        self.address=dic[@"address"];
        self.branch_name=dic[@"branch_name"];
        
        self.name=dic[@"name"];
        self.online_reservation_url=dic[@"online_reservation_url"];
        self.coupon_url=dic[@"coupon_url"];
        self.coupon_description=dic[@"coupon_description"];
        self.avg_price=[dic[@"avg_price"] intValue];
        self.review_count=[dic[@"review_count"] intValue];
        self.review_list_url=dic[@"review_list_url"];
        self.distance=[dic[@"distance"] intValue];
        self.business_url=dic[@"business_url"];
        self.photo_url=dic[@"photo_url"];
        self.s_photo_url=dic[@"s_photo_url"];
        self.photo_count=[dic[@"photo_count"] intValue];
        self.photo_list_url=dic[@"photo_list_url"];
        
        self.has_coupon=[dic[@"has_coupon"] intValue];
        self.coupon_id=[dic[@"coupon_id"] intValue];
        self.business_id=[dic[@"business_id"] intValue];
        self.has_online_reservation=[dic[@"has_online_reservation"] intValue];
        self.has_deal=[dic[@"has_deal"] intValue];
        self.deal_count=[dic[@"deal_count"] intValue];
        self.regions=dic[@"regions"];
        
        //团购列表
        NSMutableArray *dealArray=[NSMutableArray array];
        NSArray *deals=dic[@"deals"];
        for (NSDictionary *dealDic in deals) {
            DianPingDeal *deal=[[DianPingDeal alloc] initWithDic:dealDic];
            [dealArray addObject:deal];
        }
        self.deals=dealArray;
        
        
        
    }
    return self;
}

@end
