//
//  AddressBookTool.h
//  PetBook
//
//  Created by Lves Li on 15/3/19.
//  Copyright (c) 2015年 Evan Dekhayser. All rights reserved.
//  通讯录工具

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef void(^ContactSuccessBlock)(NSArray *contacts);
typedef void(^ContactFailureBlock)(NSError *error);

@interface AddressBookTool : NSObject
/*
 通过用户全称获得通讯录中的联系方式
 */
+(void)getPhonesByName:(NSString *)name Success:(ContactSuccessBlock)success andFailure:(ContactFailureBlock)failure;
/*
读取通讯录
*/
+(void)readContactsSuccess:(ContactSuccessBlock)success andFailure:(ContactFailureBlock)failure;
@end
