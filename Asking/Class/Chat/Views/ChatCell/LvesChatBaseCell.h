//
//  LvesChatBaseCell.h
//  Asking
//
//  Created by Lves Li on 14/11/14.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvesBubbleBaseView.h"
#import "MessageModel.h"


@class MessageModel;

@interface LvesChatBaseCell : UITableViewCell


/*
 设置数据源
 */
-(void)setModel:(MessageModel *)model;

/*
 获得cell的高度
*/
+(CGFloat)heightForCell:(MessageModel *)model;

@end
