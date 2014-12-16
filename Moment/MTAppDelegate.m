//
//  MTAppDelegate.m
//  Moment
//
//  Created by Jyh on 14/12/2.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MTAppDelegate.h"
#import "FindMomentViewController.h"
#import "CatchMomentViewController.h"
#import "MineViewController.h"

#import "YHBaseNavigationController.h"
#import "YHBaseTabbarController.h"
@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 设置状态栏字体为白色
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    
    
    [self initMainView];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initMainView
{
    //Find
    FindMomentViewController *findViewController = [[FindMomentViewController alloc] init];
    findViewController.tabBarItem.image = [UIImage imageNamed:@"find"];
    findViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"find_o"];
    YHBaseNavigationController *findNav = [[YHBaseNavigationController alloc] initWithRootViewController:findViewController];
    
    //Catch
    CatchMomentViewController *catchViewController = [[CatchMomentViewController alloc] init];
    catchViewController.tabBarItem.title = @"抓住瞬间";
    catchViewController.tabBarItem.image = [UIImage imageNamed:@"photo"];
    catchViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"photo_o"];
    YHBaseNavigationController *catchNav = [[YHBaseNavigationController alloc] initWithRootViewController:catchViewController];
    
    //Mine
    MineViewController *mineViewController = [[MineViewController alloc] init];
    mineViewController.tabBarItem.title = @"我的";
    mineViewController.tabBarItem.image = [UIImage imageNamed:@"myself"];
    mineViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"myself_o"];
    YHBaseNavigationController *mineNav = [[YHBaseNavigationController alloc] initWithRootViewController:mineViewController];
    
    //tabBar
    YHBaseTabbarController *rootTabBarController = [[YHBaseTabbarController alloc] init];
    rootTabBarController.viewControllers = @[findNav,catchNav,mineNav];
    [rootTabBarController setSelectedIndex:0];
    
    // setup UI Image
    
//    [rootTabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
//    [rootTabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
//    [rootTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"barbg_line1"]];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:NAVIGATION_BAR_COLCOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    }
    
    
    self.window.rootViewController = rootTabBarController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
