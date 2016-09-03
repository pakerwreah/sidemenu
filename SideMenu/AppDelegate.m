//
//  AppDelegate.m
//  MenuLateral
//
//  Created by Paker on 04/06/16.
//  Copyright © 2016 Paker. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "Menu.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[HomeViewController alloc] initWithTitle:@"Home"] menuViewController:[[Menu alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
