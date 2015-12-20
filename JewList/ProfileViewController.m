//
//  ProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserCoverCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *items;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(UserCoverCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UserCoverCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadItems];
    [self.tableView reloadData];
}

- (void)loadItems {
    self.items = [NSMutableArray array];
    [self.items addObject:self.user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.items objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[User class]]) {
        return [UserCoverCell cellHeight];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if ([object isKindOfClass:[User class]]) {
        User *user = (User *)object;
        cell = (UserCoverCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UserCoverCell.class) forIndexPath:indexPath];
        [(UserCoverCell *)cell setUser:user];
    }
    return cell;
}

@end
