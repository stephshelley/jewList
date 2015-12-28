//
//  CollegeViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "CollegeViewController.h"
#import "CollegeCell.h"
#import "College.h"
#import "SHApi.h"
#import "GraduationYearViewController.h"
#import "AppDelegate.h"

@interface CollegeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *fullCollegesArray;
@property (nonatomic) NSMutableArray *filteredCollegesArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) id fetchCollegesRequest;
@property (nonatomic) BOOL isFiltering;

@end

@implementation CollegeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(CollegeCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(CollegeCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)reloadTable {
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate -
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self processNewCharsInTextView];
}

- (void)didBeginDragging {
    [self.searchBar resignFirstResponder];
}

-(void)processNewCharsInTextView
{
    CANCEL_RELEASE_REQUEST(_fetchCollegesRequest)
    _fetchCollegesRequest = nil;
    
    [self.activityIndicator startAnimating];
    __weak __typeof(self) weakSelf = self;
    
    NSString *searchString = [[_searchBar.text lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.fetchCollegesRequest = [[SHApi sharedInstance] getSchoolsForSearchTerm:searchString
                                                                        success:^(NSArray * colleges)
                                 {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         weakSelf.fullCollegesArray = [NSMutableArray arrayWithArray:colleges];
                                         [weakSelf reloadTable];
                                         [self.activityIndicator stopAnimating];
                                     });
                                     
                                 }failure:^(NSError *error)
                                 {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [weakSelf reloadTable];
                                         [self.activityIndicator stopAnimating];
                                     });
                                 }];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchBar.text length] == 0 && [searchText length] == 0) {
        self.isFiltering = NO;
        [self.tableView reloadData];
    }
    else {
        [self processNewCharsInTextView];
    }
}

#pragma mark - UITableViewDelegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.isFiltering ?  [_filteredCollegesArray count] : [_fullCollegesArray count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CollegeCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollegeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollegeCell class])];
    
    College *item = nil;
    
    if(self.isFiltering) {
        if(indexPath.row < [_filteredCollegesArray count]) {
            item = [_filteredCollegesArray objectAtIndex:indexPath.row];
        }
    }
    else {
        if(indexPath.row < [_fullCollegesArray count]) {
            item = [_fullCollegesArray objectAtIndex:indexPath.row];
        }
    }
    cell.college = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    College *item = nil;
    
    if(self.isFiltering) {
        if(indexPath.row < [_filteredCollegesArray count]) {
            item = [_filteredCollegesArray objectAtIndex:indexPath.row];
        }
    }
    else {
        if(indexPath.row < [_fullCollegesArray count]) {
            item = [_fullCollegesArray objectAtIndex:indexPath.row];
        }
    }
    
    if(item && [item isKindOfClass:[College class]] && item.collegeName.length > 0) {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        _searchBar.text = item.collegeName;
        
        if (self.saveOnBackButton) {
            if ([self.delegate respondsToSelector:@selector(collegeViewControllerDidSelectCollege:)]) {
                [self.delegate collegeViewControllerDidSelectCollege:item];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        currentUser.school = item.collegeName;
        [[SHApi sharedInstance] cacheCurrentUserDetails];
        GraduationYearViewController *gradViewContorller = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"GraduationYearViewController"];
        gradViewContorller.user = [[SHApi sharedInstance] currentUser];
        self.navigationController.navigationBar.topItem.title = @"";
        [self.navigationController pushViewController:gradViewContorller animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

@end
