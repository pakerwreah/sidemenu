//
//  HomeViewController.m
//  MenuLateral
//
//  Created by Paker on 04/06/16.
//  Copyright © 2016 Paker. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    NSString *title;
}

-(id) initWithTitle: (NSString *) _title {
    self = [super init];
    title = _title;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(title)
        self.title = title;
}

@end
