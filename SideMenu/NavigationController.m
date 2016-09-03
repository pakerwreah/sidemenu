//
//  NavigationControllerViewController.m
//  Meeglee
//
//  Created by Paker on 03/06/16.
//
//

#import "NavigationController.h"

@interface NavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation NavigationController {
    int start_pos;
    int end_pos;
    UIView *sideView;
    UIView *backgroundView;
}


-(id)initWithRootViewController:(UIViewController *)rootViewController menuViewController:(UIViewController *)_menuController {
    self = [super initWithRootViewController:rootViewController];
    
    self.delegate = self;
    
    self.menuViewController = _menuController;
    
    backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.alpha = 0;
    
    [self.view addSubview:backgroundView];
    
    sideView = [[UIView alloc] init];
    [sideView.layer setShadowColor:[UIColor blackColor].CGColor];
    [sideView.layer setShadowOpacity:0];
    [sideView.layer setShadowRadius:3.0];
    [sideView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [sideView addSubview:_menuController.view];
    [self.view addSubview:sideView];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
    UIImage *image = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button = [[UIButton alloc] init];
    CGFloat size = self.navigationBar.bounds.size.height - 20;
    button.frame = CGRectMake(0, 0, size, size);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return self;
}

-(void) viewWillLayoutSubviews {
    if ([self.topViewController respondsToSelector:@selector(edgesForExtendedLayout)])
        self.topViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationBar.barTintColor = sideView.backgroundColor = self.menuViewController.view.backgroundColor;
    self.navigationBar.tintColor = sideView.tintColor = self.menuViewController.view.tintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : sideView.tintColor};
}

- (void)recalculateSideView {
    CGRect frame = self.topViewController.view.frame;
    
    backgroundView.frame = frame;
    backgroundView.alpha = 0;
    
    start_pos = -frame.size.width;
    end_pos = start_pos+214;
    
    frame.origin.x = start_pos;
    sideView.frame = frame;
    
    frame.origin.x = -end_pos;
    frame.origin.y = 0;
    frame.size.width = end_pos-start_pos;
    self.menuViewController.view.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationBar.translucent = NO;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self recalculateSideView];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self recalculateSideView];
     } completion:nil];
    
    [self.topViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [self hideMenu];
    [super setViewControllers:viewControllers animated:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self hideMenu];
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self hideMenu];
    return [super popViewControllerAnimated:animated];
}

-(BOOL)isShown
{
    return sideView.frame.origin.x + sideView.frame.size.width > 100;
}

- (void) showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    
    CGRect frame = sideView.frame;
    if(frame.origin.x < end_pos){
        
        // Present the view controller
        //
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = sideView.frame;
            frame.origin.x = end_pos;
            sideView.frame = frame;
            backgroundView.alpha = 1;
            
            CGRect frame2 = self.topViewController.view.frame;
            frame2.origin.x = end_pos+frame.size.width;
            self.topViewController.view.frame = frame2;
            [sideView.layer setShadowOpacity:0.8];
        }];
        
    } else {
        [self hideMenu];
    }
}

- (void) hideMenu {
    // Dismiss keyboard (optional)
    //
    if (![self isShown])
        [self.view endEditing:YES];
    
    // Hide the view controller
    //
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = sideView.frame;
        frame.origin.x = start_pos;
        sideView.frame = frame;
        backgroundView.alpha = 0;
        CGRect frame2 = self.topViewController.view.frame;
        frame2.origin.x = 0;
        self.topViewController.view.frame = frame2;
        [sideView.layer setShadowOpacity:0];
    }];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint v = [pan velocityInView:self.view];
    BOOL open = [self isShown];
    return open || v.x > 0;
}

- (void) panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    [sideView.layer setShadowOpacity:0.8];
    CGPoint point = [recognizer translationInView:self.view];
    
    BOOL open = [self isShown];
    
    CGRect frame = sideView.frame;
    CGRect frame2 = self.topViewController.view.frame;
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = sideView.frame;
            frame.origin.x = open?end_pos:start_pos;
            sideView.frame = frame;
            
            backgroundView.alpha = open?1:0;
            
            CGRect frame2 = self.topViewController.view.frame;
            frame2.origin.x = open?end_pos+frame.size.width:0;
            self.topViewController.view.frame = frame2;
            if(!open)
                [sideView.layer setShadowOpacity:0];
        }];
    }
    else if(frame.origin.x+point.x<0 && frame.origin.x+point.x>=start_pos)
    {
        frame.origin.x += point.x;
        sideView.frame = frame;
        backgroundView.alpha = 1;
        frame2.origin.x = frame.origin.x+frame.size.width;
        self.topViewController.view.frame = frame2;
        
        if(open)
            [self.view endEditing:YES];
    }
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}

/*
 * Permite com que o view controller atual decida a orientação
 */

#pragma mark - rotation iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Delega para o View Controller atual (é o último do array)
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - rotation iOS 6
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    // Delega para o View Controller atual (é o último do array)
    return [self.topViewController supportedInterfaceOrientations];
}


@end
