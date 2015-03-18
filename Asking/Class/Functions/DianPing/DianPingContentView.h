//
//  DianPingContentView.h
//  Asking
//
//  Created by Lves Li on 15/3/5.
//  Copyright (c) 2015年 Lves. All rights reserved.
//

#import "CellContentBaseView.h"
#import "DianPingView.h"
@interface DianPingContentView : CellContentBaseView
{
    DianPingView *firstDianPingView;
    DianPingView *secondDianPingView;
    DianPingView *thirdDianPingView;
    UIButton *moreBtn;
}
@property (nonatomic,strong) DianPingView *firstDianPingView;
@property (nonatomic,strong) DianPingView *secondDianPingView;
@property (nonatomic,strong) DianPingView *thirdDianPingView;
@property (nonatomic,strong) UIButton *moreBtn;

@end
