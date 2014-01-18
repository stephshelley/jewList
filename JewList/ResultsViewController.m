//
//  ResultsViewController.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "ResultsViewController.h"
#import "UserResultCell.h"
#import "SHApi.h"
#import "User.h"
#import "SHProfileViewController.h"
#import "SHUserCellItem.h"
#import "SHEditProfileViewController.h"

@implementation ResultsViewController


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DEFAULT_BLUE_COLOR;
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.title = @"Results";
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 24)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:titleLabel.height-2];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.centerX = floorf(topView.width/2);
    titleLabel.centerY = floorf(topView.height/2);
    [topView addSubview:titleLabel];
    
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [profileButton setTitle:@"Profile" forState:UIControlStateNormal];
    [profileButton setTitle:@"Profile" forState:UIControlStateHighlighted];
    profileButton.titleLabel.textAlignment = NSTextAlignmentRight;
    profileButton.titleLabel.backgroundColor = [UIColor clearColor];
    profileButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    profileButton.backgroundColor = [UIColor clearColor];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    profileButton.centerY = titleLabel.centerY;
    profileButton.right = topView.width - 10;
    [profileButton addTarget:self action:@selector(openProfile) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:profileButton];
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(openProfile)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, self.view.height - topView.height - (IS_IOS7 ? 20 : 0)) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UserResultCell class] forCellReuseIdentifier:NSStringFromClass([UserResultCell class])];
    
    [self.view addSubview:self.tableView];
    [self showLoading];
    [self.dataSource loadModel];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IS_IOS7) [self setNeedsStatusBarAppearanceUpdate];

    
}

- (void)openProfile
{
    User *currentUser = [[SHApi sharedInstance] currentUser];
    User *currentUserCopy = [currentUser copy];
    
    SHEditProfileViewController *vc = [[SHEditProfileViewController alloc] initWithUser:currentUserCopy];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (SHMemberResultsDataSource *)dataSource
{
    if(nil == _dataSource)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _dataSource = [[SHMemberResultsDataSource alloc] initWithCollege:currentUser.college];
        _dataSource.delegate = self;
        
    }
    
    return _dataSource;
    
}

- (void)showLoading
{
    if(nil == _activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.view.center;
        [self.view addSubview:_activityView];
        _activityView.hidesWhenStopped = YES;

    }
    
    [_activityView startAnimating];
    _tableView.hidden = YES;

}

- (void)hideloading
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    _tableView.hidden = NO;

}

#pragma mark - STBaseDataSource Delegate -

- (void)dataSourceLoaded:(id)dataSource
{
    [self hideloading];
    [_tableView reloadData];
    
}

- (void)dataSourceError:(NSError *)error
{
    
}

#pragma mark - UITableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserResultCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserResultCell class])];
    cell = [[UserResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UserResultCell class])];
    SHUserCellItem *item = [_dataSource.items objectAtIndex:indexPath.row];
    cell.item = item;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHUserCellItem *item = [_dataSource.items objectAtIndex:indexPath.row];
    SHProfileViewController *userVC = [[SHProfileViewController alloc] initWithUser:item.user];
    [self.navigationController pushViewController:userVC animated:YES];
    
}



@end
