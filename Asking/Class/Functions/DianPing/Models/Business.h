//
//  Business.h
//  DianPingDemo
//
//  Created by Lves Li on 15/3/4.
//  Copyright (c) 2015年 lves All rights reserved.
//  商户信息

#import <Foundation/Foundation.h>

@interface Business : NSObject
///人均价格，单位:元，若没有人均，返回-1
@property (nonatomic,assign) int avg_price;
///点评数量
@property (nonatomic,assign) int review_count;
///点评页面URL链接
@property (nonatomic,copy) NSString *review_list_url;
///距离
@property (nonatomic,assign)int distance;
///商户页面链接
@property (nonatomic,copy)NSString *business_url;
///照片链接，照片最大尺寸700×700
@property (nonatomic,copy) NSString *photo_url;
///小尺寸照片链接，照片最大尺寸278×200
@property (nonatomic,copy) NSString *s_photo_url;
///照片页面URL链接
@property (nonatomic,copy) NSString *photo_list_url;
///优惠券描述
@property (nonatomic,copy) NSString *coupon_description;
///优惠券页面链接
@property (nonatomic,copy) NSString *coupon_url;
///在线预订页面链接，目前仅返回HTML5站点链接
@property (nonatomic,copy) NSString *online_reservation_url;
///商户名
@property (nonatomic,copy) NSString *name;
///分店名
@property (nonatomic,copy) NSString *branch_name;
///地址
@property (nonatomic,copy) NSString *address;
///带区号的电话
@property (nonatomic,copy) NSString *telephone;
///所在城市
@property (nonatomic,copy) NSString *city;
///所在区域信息列表
@property (nonatomic,strong) NSArray *regions;
///星级评分，5.0代表五星，4.5代表四星半，依此类推
@property (nonatomic,assign) float avg_rating;
///星级图片链接
@property (nonatomic,copy) NSString *rating_img_url;
///小尺寸星级图片链接
@property (nonatomic,copy) NSString *rating_s_img_url;
///照片数量
@property (nonatomic,assign)int photo_count;
///是否有优惠券 0:没有，1:有
@property (nonatomic,assign)int has_coupon;
///是否有团购，0:没有，1:有
@property (nonatomic,assign)int has_deal;
///商户当前在线团购数量
@property (nonatomic,assign)int deal_count;
///团购列表
@property (nonatomic,strong) NSArray *deals;
///是否有在线预订，0:没有，1:有
@property (nonatomic,assign)int has_online_reservation;
///商户ID
@property (nonatomic,assign) int business_id;
///优惠劵ID
@property (nonatomic,assign)int coupon_id;



-(id)initWithDic:(NSDictionary *)dic;




@end
