//
//  AppDelegate.m
//  CBDemo
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import "AppDelegate.h"
#import "CBSVC.h"
#import "CBOneViewController.h"
#import "CBTwoViewController.h"
#import "CBThreeViewController.h"
#import "CBFourViewController.h"
#import "CBFiveViewController.h"
#import "CBSixViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /**
     *  创建CBScrollViewController步骤：
     1.创建CBTitleButton
     2.将CBTitleButton添加到数组
     3.调用初始化方法创建CBScrollViewController
     注意：当添加UITableViewController(及其子类)到CBScrollViewController上时，需要设置其tableView.frame.origin.y = 0(默认有20的状态栏留白)
     */
    
    //1.创建CBTitleButton
    CBTitleButton *btnOne = [CBTitleButton titleButtonWithName:@"one" viewController:[[CBOneViewController alloc] init]];
    
    CBTitleButton *btnTwo = [CBTitleButton titleButtonWithName:@"two" viewController:[[CBTwoViewController alloc] init]];
    
    CBTitleButton *btnThree = [CBTitleButton titleButtonWithName:@"three" viewController:[[CBThreeViewController alloc] init]];
    
    CBTitleButton *btnFour = [CBTitleButton titleButtonWithName:@"four" viewController:[[CBFourViewController alloc] init]];
    
    CBTitleButton *btnFive = [CBTitleButton titleButtonWithName:@"five" viewController:[[CBFiveViewController alloc] init]];
    
    CBTitleButton *btnSix = [CBTitleButton titleButtonWithName:@"six" viewController:[[CBSixViewController alloc] init]];
    
    //2.将CBTitleButton添加到数组
    NSArray *titleButtonArray = @[btnOne, btnTwo, btnThree, btnFour, btnFive, btnSix];
    
    //3.调用初始化方法创建CBScrollViewController
    CBScrollViewController *scrollVC = [CBScrollViewController scrollViewControllerWithTitleButtonArray:titleButtonArray];
    
    //4.将CBScrollViewController添加到UINavigationController上
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scrollVC];
    
    // 5.设置window的rootViewController
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
