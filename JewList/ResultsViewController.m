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
    self.title = @"Results";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(openProfile)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44 - (IS_IOS7 ? 20 : 0)) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UserResultCell class] forCellReuseIdentifier:NSStringFromClass([UserResultCell class])];
    
    [self.view addSubview:self.tableView];
    [self showLoading];
    [self.dataSource generateDemoItems];

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
    
    if(!IS_IOS6)
    {
        if(nil == cell)
        {
            cell = [[UserResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UserResultCell class])];
        }
        
    }
    
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
