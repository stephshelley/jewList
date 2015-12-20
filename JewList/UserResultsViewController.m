//
//  UserResultsViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "UserResultsViewController.h"
#import "UserCell.h"
#import "SHMemberResultsDataSource.h"
#import "SHApi.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface UserResultsViewController () <STBaseDataSource, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SHMemberResultsDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noResultsLabel;

@end

@implementation UserResultsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(UserCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UserCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.activityIndicator startAnimating];
    [self.dataSource loadModel];
}

- (SHMemberResultsDataSource *)dataSource {
    if(!_dataSource) {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _dataSource = [[SHMemberResultsDataSource alloc] initWithCollege:currentUser.college];
        _dataSource.delegate = self;
    }
    return _dataSource;
}

- (void)refreshScreen {
    User *currentUser = [[SHApi sharedInstance] currentUser];
    _dataSource.college = currentUser.college;
    _dataSource.model.college = currentUser.college;
    [self.dataSource reloadModel];
}

#pragma mark - STBaseDataSourceDelegate

- (void)dataSourceLoaded:(id)dataSource {
    [self.activityIndicator stopAnimating];
    //[_pullToRefreshManager tableViewReloadFinishedAnimated:YES];
    self.noResultsLabel.hidden = self.dataSource.items.count != 0;
    [self.tableView reloadData];
}

- (void)dataSourceError:(NSError *)error {
    self.noResultsLabel.hidden = self.dataSource.items.count != 0;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UserCell.class) forIndexPath:indexPath];
    User *user = [self.dataSource.items objectAtIndex:indexPath.row];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileViewController *profileViewController = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    User *user = [self.dataSource.items objectAtIndex:indexPath.row];
    profileViewController.user = user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

/*
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
 */

@end
