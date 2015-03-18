//
//  AppDelegate.h
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    ///用户坐标
    CLLocationCoordinate2D userLocation;
    ///用户所在城市
    NSString *cityName;
    ///城区
    NSString *district;
}

@property (nonatomic,assign) CLLocationCoordinate2D userLocation;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *district;


@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

