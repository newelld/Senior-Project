//
//  gvsuAppDelegate.m
//  Philanthropy
//
//  Created by Nickolas Workman on 1/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//
 
#import "gvsuAppDelegate.h"

#import "HomeScreenViewController.h"
#import "MapViewController.h"
#import "DirectoryViewController.h"
#import "ClosestViewController.h"
#import "DonateViewController.h"


@implementation gvsuAppDelegate

@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //GOOGLE MAPS API KEY
    [GMSServices provideAPIKey:@"AIzaSyB6tYqL5rFg3H-G1BsaPrUlL8dzvbJLBc0"];

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    
    
    UIViewController *homescreen = [[HomeScreenViewController alloc]
        initWithNibName:@"HomeScreenViewController" bundle:nil];
   
    MapViewController *ma = [[MapViewController alloc]
                                    initWithNibName:@"MapViewController" bundle:nil];
    
    UINavigationController *map = [[UINavigationController alloc]
        initWithRootViewController:ma];
    
    DirectoryViewController *dir = [[DirectoryViewController alloc]
                                  initWithNibName:@"DirectoryViewController" bundle:nil];
    
    UINavigationController *directory = [[UINavigationController alloc]
                                       initWithRootViewController:dir];
    
    ClosestViewController *clo = [[ClosestViewController alloc]
                                  initWithNibName:@"DirectoryViewController" bundle:nil];
    
    UINavigationController *closest = [[UINavigationController alloc]
                                             initWithRootViewController:clo];
    
    UIViewController *donate = [[DonateViewController alloc]
                             initWithNibName:@"DonateViewController" bundle:nil];
    
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: homescreen, map, directory, closest, donate, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [self customizeAppearance];
    return YES;
}

-(void)customizeAppearance
{
    UIImage *navbarBackground = [UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navbarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonBackground = [UIImage imageNamed:@"back-button.png"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonBackground  forState:UIControlStateNormal barMetrics: UIBarMetricsDefault];
    
    UIImage *searchBackground = [UIImage imageNamed:@"searchbar.png"];
    [[UISearchBar appearance] setBackgroundImage:searchBackground];
    
    UIImage *cancelButtonBackground = [UIImage imageNamed:@"navbar-icon.png"];
    UIBarButtonItem *searchBarButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [searchBarButton setBackgroundImage:cancelButtonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *tabbarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabbarBackground];
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
