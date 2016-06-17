//
//  AppDelegate.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "AppDelegate.h"
#import "ZciotTabbarController.h"
#import "zciotNetRequest.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [zciotNetRequest ZciotNetWorkReachabilityWithURLString:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    ZciotTabbarController *vc =[ZciotTabbarController new];
    self.window.rootViewController = vc;
    return YES;
}
-(void)reachabilityChanged:(NSNotification *)note
{
    
    if ([note.userInfo isEqual:@{ AFNetworkingReachabilityNotificationStatusItem: @(AFNetworkReachabilityStatusNotReachable) }]) {
        NSLog(@"diaoxian");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"无法访问！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
}

// 将得到的deviceToken传给SDK
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    
//    NSString* deviceTokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]; // null?
//    NSLog(@"%@",deviceTokenStr);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if (![userDefaults objectForKey:KEY_DeviceTokenString]) {
//        if (deviceToken) {
//            deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
//            NSLog(@"%@",deviceTokenStr);
//            deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)]
//                              substringWithRange:NSMakeRange(1, 71)];
//            deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            self.phoneImei =deviceTokenStr;
//            //保存token
//            [userDefaults setObject:deviceTokenStr forKey:KEY_DeviceTokenString];
//            [userDefaults synchronize];
//            
//        }
//    }else{
//        self.phoneImei =[userDefaults objectForKey:KEY_DeviceTokenString];
//    }
//    
//    
//    //[[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//}
//向服务器申请发送token 判断事前有没有发送过
- (void)registerForRemoteNotificationToGetToken
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
}

//允许的话 自动回调的函数
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
        NSString* deviceTokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]; // null?
        NSLog(@"%@",deviceTokenStr);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (![userDefaults objectForKey:KEY_DeviceTokenString]) {
            if (deviceToken) {
                deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
                NSLog(@"%@",deviceTokenStr);
                deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)]
                                  substringWithRange:NSMakeRange(1, 71)];
                deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                self.phoneImei =deviceTokenStr;
                //保存token
                [userDefaults setObject:deviceTokenStr forKey:KEY_DeviceTokenString];
                [userDefaults synchronize];
    
            }
        }else{
            self.phoneImei =[userDefaults objectForKey:KEY_DeviceTokenString];
        }
    
    
        //[[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
//    //将device token转换为字符串
//    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
//    
//    
//    //modify the token, remove the  "<, >"
//    NSLog(@"    deviceTokenStr  lentgh:  %d  ->%@", [deviceTokenStr length], [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)]);
//    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
//    
//    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
//    
//    
//    //将deviceToken保存在NSUserDefaults
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    //保存 device token 令牌,并且去掉空格
//    [userDefaults setObject:[deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:KEY_DeviceTokenString];
//    
//    
//    
//    
//    //send deviceToken to the service provider
//    
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//        
//        //没有在service provider注册Device Token, 需要发送令牌到服务器
//        if ( ![userDefaults boolForKey:KEY_DeviceTokenString] )
//        {
//            NSLog(@" 没有 注册Device Token");
//            //[self sendProviderDeviceToken:deviceTokenStr];
//        }
//    });
    
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"获取令牌失败:  %@",str);
    
    //如果device token获取失败则需要重新获取一次
    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
}



//获取远程通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSLog(@"the badge number is  %d",  [[UIApplication sharedApplication] applicationIconBadgeNumber]);
    NSLog(@"the application  badge number is  %d",  application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber += 1;
    
    
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    //当用户打开程序时候收到远程通知后执行
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[NSString stringWithFormat:@"\n%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
            application.applicationIconBadgeNumber = 0;
            
            //ask the provider to set the BadgeNumber to zero
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *deviceTokenStr = [userDefaults objectForKey:KEY_DeviceTokenString];
           // [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
        });
        
        [alertView show];
        //[alertView release];
        
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //每次醒来都需要去判断是否得到device token
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    //hide the badge
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "---.zciotRequestOC" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"zciotRequestOC" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"zciotRequestOC.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
