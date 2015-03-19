//
//  AddressBookTool.m
//  PetBook
//
//  Created by Lves Li on 15/3/19.
//  Copyright (c) 2015年 Evan Dekhayser. All rights reserved.
//

#import "AddressBookTool.h"
@implementation AddressBookTool

#pragma mark 根据用户名获得电话

+(void)getPhonesByName:(NSString *)name Success:(ContactSuccessBlock)success andFailure:(ContactFailureBlock)failure{
    
    [self readContactsSuccess:^(NSArray *contacts) {
        NSMutableArray *resultContact=[NSMutableArray array];
        //便利通讯录获得结果
        for (NSDictionary *person in contacts) {
            //获得通讯录名字
            NSArray *nameArray= person.allKeys;
            NSString *nikeName;
            if (nameArray.count>0) {
                nikeName=nameArray.firstObject;
            }
            //判断是否是想要的好友
            if (nikeName.length>0&&[nikeName isEqualToString:name]) {
                [resultContact addObject:person];
                
            }
        }
        
        if (success) {
            success(resultContact);
        }
        
        
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];


}



#pragma mark  读取通讯录
+(void)readContactsSuccess:(ContactSuccessBlock)success andFailure:(ContactFailureBlock)failure{
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        NSError *error=[NSError errorWithDomain:@"没有权限" code:100 userInfo:nil];
        if(failure){
            failure(error);
        }
        
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){  //允许读取
        NSArray *contactsArray=[self getContacts];
        if(success){
            success(contactsArray);
        }
        
    } else{
        //3 询问访问通讯录权限必须在主线程中
        dispatch_async(dispatch_get_main_queue(), ^{
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
                if (!granted){
                    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantAddContactAlert show];
                    
                    NSError *error=[NSError errorWithDomain:@"没有权限" code:100 userInfo:nil];
                    if(failure){
                        failure(error);
                    }
                    return;
                }
                NSArray *contactsArray=[self getContacts];
                if(success){
                    success(contactsArray);
                }
            });
            
        });
    } 
    
}
+(NSArray *)getContacts{
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    NSMutableArray *contactsArray=[NSMutableArray array];
    //遍历通讯录
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        //获得单个人
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        NSString  *name= (__bridge NSString *) ABRecordCopyCompositeName(person);
        
        
        //读取电话多值
        NSMutableArray *phoneArray=[NSMutableArray array];
        ABMultiValueRef phoneValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phoneValueRef); k++)
        {
            //获取电话Label
            //            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneValueRef, k);
            if (personPhone.length>0) {
                [phoneArray addObject:personPhone];
            }
            
        }
        if (name.length>0) {
            NSDictionary *personDic=[NSDictionary dictionaryWithObject:phoneArray forKey:name];
            [contactsArray addObject:personDic];
        }
        
        
    }
    return contactsArray;


}


#pragma mark 添加通讯录
- (void)addPetToContacts: (UIButton *) petButton{
    NSString *petFirstName;
    NSString *petLastName;
    NSString *petPhoneNumber;
    NSData *petImageData;
    if (petButton.tag == 1){
        petFirstName = @"Cheesy";
        petLastName = @"Cat";
        petPhoneNumber = @"2015552398";
        petImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"contact_Cheesy.jpg"], 0.7f);
    } else if (petButton.tag == 2){
        petFirstName = @"Freckles";
        petLastName = @"Dog";
        petPhoneNumber = @"3331560987";
        petImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"contact_Freckles.jpg"], 0.7f);
    } else if (petButton.tag == 3){
        petFirstName = @"Maxi";
        petLastName = @"Dog";
        petPhoneNumber = @"5438880123";
        petImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"contact_Maxi.jpg"], 0.7f);
    } else if (petButton.tag == 4){
        petFirstName = @"Shippo";
        petLastName = @"Dog";
        petPhoneNumber = @"7124779070";
        petImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"contact_Shippo.jpg"], 0.7f);
    }
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef pet = ABPersonCreate();
    //设置姓名
    ABRecordSetValue(pet, kABPersonFirstNameProperty, (__bridge CFStringRef)petFirstName, nil);
    ABRecordSetValue(pet, kABPersonLastNameProperty, (__bridge CFStringRef)petLastName, nil);
    
    //添加电话
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)petPhoneNumber, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(pet, kABPersonPhoneProperty, phoneNumbers, nil);
    //设置头像
    ABPersonSetImageData(pet, (__bridge CFDataRef)petImageData, nil);
    
    
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        if (CFStringCompare(ABRecordCopyCompositeName(thisContact),
                            ABRecordCopyCompositeName(pet), 0) == kCFCompareEqualTo){
            //The contact already exists!
            UIAlertView *contactExistsAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"There can only be one %@", petFirstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [contactExistsAlert show];
            return;
        }
    }
    //添加联系人保存到
    ABAddressBookAddRecord(addressBookRef, pet, nil);
    ABAddressBookSave(addressBookRef, nil);
    
    UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [contactAddedAlert show];
    
}


@end
