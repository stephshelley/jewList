//
//  SHOnboardingStep2View.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHOnboarding2View.h"
#import "SHCollegeCell.h"
#import "College.h"
#import "SHApi.h"
#import "User.h"

@implementation SHOnboarding2View

- (id)initWithFrame:(CGRect)frame andUser:(User*)user
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.user = user;
        self.fullCollegesArray = [[NSMutableArray alloc] init];
        self.filteredCollegesArray = [[NSMutableArray alloc] init];

        
        [self loadUI];
        
    }
    
    return self;
    
}

- (void)loadUI
{
    self.backgroundColor = [UIColor whiteColor];

    self.collegeTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
    _collegeTopView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_collegeTopView];

    
    self.collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _collegeTopView.width - 20, 26)];
    _collegeLabel.textAlignment = NSTextAlignmentCenter;
    _collegeLabel.font = [UIFont fontWithName:DEFAULT_FONT size:_collegeLabel.height-2];
    _collegeLabel.centerX = floorf(_collegeTopView.width/2);
    _collegeLabel.centerY = floorf(_collegeTopView.height/2);
    _collegeLabel.textColor = [UIColor whiteColor];
    _collegeLabel.backgroundColor = [UIColor grayColor];
    _collegeLabel.adjustsFontSizeToFitWidth = YES;
    _collegeLabel.text = @"What college are you going to?";
    [self addSubview:_collegeLabel];

    
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _nextStepButton.backgroundColor = [UIColor blueColor];
    _nextStepButton.bottom = self.height - 5;
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateHighlighted];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = _collegeTopView.centerX;
    [self addSubview:_nextStepButton];
    
    [self loadTable];
}

- (void)loadTable
{
    CGFloat width = self.width;
    CGFloat height = 400;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5, 0, width + 10, 44)];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"add_friends_input2"] forState:UIControlStateNormal];
    
    _searchBar.top = _collegeTopView.bottom;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = NSLocalizedString(@"search", @"Search");
    self.searchBar.delegate = self;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.searchBar setShowsCancelButton:NO animated:NO];
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"empty_pixel"]];
    
    if(_user.fbCollegeName.length > 0)
    {
        _searchBar.text = _user.fbCollegeName;
    }
    
    [self addSubview:self.searchBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, width,height - self.searchBar.bottom - (IsIpad ? 44.0 : 10.0)) style:UITableViewStylePlain];
    
    if(!IsIpad)
    {
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if(IS_IOS6)
        [self.tableView registerClass:[SHCollegeCell class] forCellReuseIdentifier:NSStringFromClass([SHCollegeCell class])];
    
    [self addSubview:self.tableView];
    
}

-(void)touchOverlay:(id)sender {
    [self searchBarCancelButtonClicked:_searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {                   // called when cancel button pressed
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{                     // called when keyboard search button pressed
    [_searchBar resignFirstResponder];
}

- (void)didBeginDragging {
    [_searchBar resignFirstResponder];
    
}

-(void)processNewCharsInTextView
{
    _filteredCollegesArray = nil;
    
    _filteredCollegesArray = [[NSMutableArray alloc] init];
    
    for(College *college in self.fullCollegesArray)
    {
        NSRange textRange =[[college.name lowercaseString] rangeOfString:[_searchBar.text lowercaseString]];
                
        if(textRange.location != NSNotFound && [college.name length]>0)
        {
            [_filteredCollegesArray addObject:college];
            
        }
        
    }
    
    isFiltering = YES;
    [self.tableView reloadData];
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchBar.text length]==0 && [searchText length]==0)
    {
        //[self deselectItems];
        isFiltering = NO;
        [self.tableView reloadData];
        
    }else{
        [self processNewCharsInTextView];
        
    }
    
}

- (void)reloadTable
{
    [self.tableView reloadData];
}

#pragma mark == UITableView Delegate ==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = isFiltering ?  [_filteredCollegesArray count] : [_fullCollegesArray count];
    return count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SHCollegeCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHCollegeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCollegeCell class])];
    
    if(!IS_IOS6)
    {
        if(nil == cell)
        {
            cell = [[SHCollegeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SHCollegeCell class])];
        }
    }
    
    College *item = nil;
    
    if(isFiltering)
    {
        if(indexPath.row < [_filteredCollegesArray count])
            item = [_filteredCollegesArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        if(indexPath.row < [_fullCollegesArray count])
            item = [_fullCollegesArray objectAtIndex:indexPath.row];
        
    }

    if(item && [item isKindOfClass:[College class]])
    {
        cell.nameLabel.text = item.name;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    College *item = nil;
    
    if(isFiltering)
    {
        if(indexPath.row < [_filteredCollegesArray count])
            item = [_filteredCollegesArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        if(indexPath.row < [_fullCollegesArray count])
            item = [_fullCollegesArray objectAtIndex:indexPath.row];
        
    }
    
    if(item && [item isKindOfClass:[College class]] && item.name.length > 0)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        currentUser.fbCollegeName = item.name;
        [[SHApi sharedInstance] cacheCurrentUserDetails];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    
}

@end
