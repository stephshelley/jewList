//
//  ProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserCoverCell.h"
#import "ProfileDetailCell.h"
#import "ProfileDetailCellItem.h"
#import "MessageViewController.h"
#import "MultiSelectionHelpers.h"
#import "FreeTextHelpers.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *items;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(UserCoverCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UserCoverCell.class)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ProfileDetailCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ProfileDetailCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0;
    [self loadItems];
    [self.tableView reloadData];
    
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithTitle:@"Contact" style:UIBarButtonItemStylePlain target:self action:@selector(onContactButton:)];
    self.navigationItem.rightBarButtonItem = contactButton;
}

- (void)onContactButton:(id)sender {
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.receipent = self.user;
    [self presentViewController:messageVC animated:YES completion:nil];
}


- (void)loadItems {
    self.items = [NSMutableArray array];
    [self.items addObject:self.user];

    for (NSUInteger index = FreeTextTypeAboutMe; index <= FreeTextTypeDesiredMajor; index ++) {
        
        ProfileDetailCellItem *item = [ProfileDetailCellItem new];
        item.title = [FreeTextHelpers questionTitleForType:index];
        item.detail = [FreeTextHelpers userValueForType:index user:_user];
        if (item.detail.length == 0) continue;
        [self.items addObject:item];
    }
    
    for (NSUInteger index = MultiSelectionTypeGender; index <= MultiSelectionTypeWantContactFromJewishOrganizations; index ++) {
        
        ProfileDetailCellItem *item = [ProfileDetailCellItem new];
        item.title = [MultiSelectionHelpers questionTitleForType:index];
        item.detail = [MultiSelectionHelpers userValueForType:index user:_user];
        if (item.detail.length == 0) continue;
        [self.items addObject:item];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.items objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[User class]]) {
        return [UserCoverCell cellHeight];
    }
    else if ([object isKindOfClass:[ProfileDetailCellItem class]]) {
        return UITableViewAutomaticDimension;

        ProfileDetailCellItem *item = (ProfileDetailCellItem *)object;
        return [ProfileDetailCell cellHeightForItem:item];
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
    else if ([object isKindOfClass:[ProfileDetailCellItem class]]) {
        ProfileDetailCellItem *item = (ProfileDetailCellItem *)object;
        cell = (ProfileDetailCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ProfileDetailCell.class) forIndexPath:indexPath];
        [(ProfileDetailCell *)cell setItem:item];
    }
    return cell;
}

@end
