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

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen) name:kRefreshResultsScreenNotification object:nil];
    }
    
    return self;
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DEFAULT_BLUE_COLOR;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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
    
    UIButton *profileButton = [SHUIHelpers getNavBarButton:CGRectMake(0, 0, 60, 24) title:@"Profile" selector:@selector(openProfile) sender:self];
    profileButton.centerY = titleLabel.centerY;
    profileButton.right = topView.width - 10;
    [topView addSubview:profileButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, self.view.height - topView.height - 20) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UserResultCell class] forCellReuseIdentifier:NSStringFromClass([UserResultCell class])];
    [self.view addSubview:self.tableView];
    
    self.emptyResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 60, 40)];
    _emptyResultsLabel.backgroundColor = [UIColor clearColor];
    _emptyResultsLabel.textAlignment = NSTextAlignmentCenter;
    _emptyResultsLabel.text = @"No results available";
    _emptyResultsLabel.centerY = (self.view.height/2);
    _emptyResultsLabel.centerX = self.view.width/2;
    _emptyResultsLabel.hidden = YES;
    _emptyResultsLabel.textColor = DEFAULT_DARK_GRAY_COLOR;
    [self.view addSubview:_emptyResultsLabel];
    
    [self showLoading];
    [self.dataSource loadModel];
    

}

- (void)refreshScreen
{
    User *currentUser = [[SHApi sharedInstance] currentUser];
    _dataSource.college = currentUser.college;
    _dataSource.model.college = currentUser.college;
    [self.dataSource reloadModel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pullToRefreshManager = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:_tableView
                                                                                  withClient:self];

    
    [self setNeedsStatusBarAppearanceUpdate];
    
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
    [_pullToRefreshManager tableViewReloadFinishedAnimated:YES];

    _emptyResultsLabel.hidden = _dataSource.items.count != 0;
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


#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_pullToRefreshManager tableViewReleased];
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager {
    
    [self refreshScreen];
    
}

@end
