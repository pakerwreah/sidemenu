//
//  Menu.m
//  Meeglee
//
//  Created by Paker on 03/06/16.
//
//

#import "Menu.h"
#import "HomeViewController.h"

@interface Menu ()

@end

@implementation Menu {
    NSArray *itens;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itens = @[@"Item 1",@"Item 2",@"Item 3",@"Item 4",@"Item 5"];
    
    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    
    // Navigationbar text/button color
    self.tableView.tintColor = [UIColor whiteColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Header view
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 100, 100)];
    imageView.image = [UIImage imageNamed:@"user_photo"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 50;
    imageView.layer.masksToBounds = YES;
    [header addSubview:imageView];
    
    self.tableView.tableHeaderView = header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"Celula";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = itens[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *navigationController = (UINavigationController *)self.view.window.rootViewController;
    
    // Push the view controller.
    [navigationController pushViewController:[[HomeViewController alloc] initWithTitle:itens[indexPath.row]] animated:YES];
}

@end
