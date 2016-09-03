//
//  NavigationControllerViewController.h
//  Meeglee
//
//  Created by Paker on 03/06/16.
//
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

@property (nonatomic) UIViewController *menuViewController;

- (id) initWithRootViewController:(UIViewController *)rootViewController menuViewController:(UIViewController *)menuViewController;
- (void) showMenu;
- (void) hideMenu;
- (BOOL) isShown;

@end
