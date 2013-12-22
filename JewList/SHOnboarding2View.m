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
#import "JLColors.h"
#import <QuartzCore/QuartzCore.h>
#import "SHUIHelpers.h"

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

- (void)popScreen
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToPreviousStep:)])
        [_delegate goToPreviousStep:self];
    
    [_searchBar resignFirstResponder];

}

- (void)loadUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 20 : 0, self.frame.size.width, 5)];
    progressBar.backgroundColor = [UIColor JLGreen];
    UIView *progressMade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (progressBar.width/4)*2 , progressBar.height)];
    progressMade.backgroundColor = [UIColor JLDarkGreen];
    [progressBar addSubview:progressMade];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:progressBar.frame];
    progressLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.text = @"Step 2/3";
    progressLabel.centerY = floorf(progressBar.height/2);
    //[progressBar addSubview:progressLabel];
    [self addSubview:progressBar];

    self.collegeTopView = [[UIView alloc] initWithFrame:CGRectMake(0, progressBar.bottom, self.width, 50)];
    _collegeTopView.backgroundColor = [UIColor JLGrey];
    [self addSubview:_collegeTopView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(_collegeTopView.height/2);
    leftButtonView.left = -2;
    [_collegeTopView addSubview:leftButtonView];
    
    self.collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _collegeTopView.width, _collegeTopView.height)];
    _collegeLabel.textAlignment = NSTextAlignmentCenter;
    _collegeLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _collegeLabel.textColor = [UIColor whiteColor];
    _collegeLabel.backgroundColor = [UIColor clearColor];
    _collegeLabel.text = @"What college are you going to?";
    [_collegeTopView addSubview:_collegeLabel];
    
    /*
    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-buttonHeight, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_nextStepButton setTitle:@"Yep, that's my school!" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Yep, that's my school!" forState:UIControlStateHighlighted];
    _nextStepButton.bottom = self.height + 40;
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = _collegeTopView.centerX;
    [self addSubview:_nextStepButton];
    */
    
    [self loadTable];
    //[self loadColleges];
}

- (void)loadColleges
{
    __weak __block SHOnboarding2View *weakSelf = self;
    [self showLoading];
    
    [[SHApi sharedInstance] getColleges:^(NSArray *colleges)
     {
         self.fullCollegesArray = [NSMutableArray arrayWithArray:colleges];
         
         dispatch_async(dispatch_get_main_queue(), ^{

             [weakSelf reloadTable];
             [weakSelf hideLoading];

         });

         
     }failure:^(NSError *error)
     {
         [weakSelf hideLoading];

     }];
}

- (void)showLoading
{
    if(nil == _activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = _tableView.center;
        [self addSubview:_activityView];
        [_activityView startAnimating];
        _activityView.hidesWhenStopped = YES;
    }

}

- (void)hideLoading
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    
}


- (void)loadTable
{
    CGFloat width = self.width;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"add_friends_input2"] forState:UIControlStateNormal];
    
    _searchBar.top = _collegeTopView.bottom;
    self.searchBar.backgroundColor = UIColorFromRGB(0xd4d5d5);
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = NSLocalizedString(@"search", @"Search");
    self.searchBar.delegate = self;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.searchBar setShowsCancelButton:NO animated:NO];
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"empty_pixel"]];
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.layer.borderColor = [UIColor JLGrey].CGColor;
    
    if(_user.fbCollegeName.length > 0)
    {
        //_searchBar.text = _user.fbCollegeName;
    }
    
    [self addSubview:self.searchBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, width,self.height - _searchBar.bottom + 44) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if(!IsIpad)
    {
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = UIColorFromRGB(0x101213);
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
    [self processNewCharsInTextView];
}

- (void)didBeginDragging {
    [_searchBar resignFirstResponder];
    
}

-(void)processNewCharsInTextView
{
    CANCEL_RELEASE_REQUEST(_fetchCollegesRequest)
    _fetchCollegesRequest = nil;
    
    [self showLoading];
    __weak __block SHOnboarding2View *weakSelf = self;

    self.fetchCollegesRequest = [[SHApi sharedInstance] getSchoolsForSearchTerm:[_searchBar.text lowercaseString]
                                                                        success:^(NSArray * colleges)
                                 {
                                    
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         weakSelf.fullCollegesArray = colleges;
                                         [weakSelf reloadTable];
                                         [weakSelf hideLoading];
                                         
                                     });

                                 }failure:^(NSError *error)
                                 {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         [weakSelf reloadTable];
                                         [weakSelf hideLoading];
                                         
                                     });
   
                                 }];
    
    
    /*
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
     */
    
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
        //[self processNewCharsInTextView];
        
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
        
        _searchBar.text = item.name;
        
    }
    
    _user.college = item;
    
    if(_delegate && [_delegate respondsToSelector:@selector(continueToNextStep:)])
        [_delegate continueToNextStep:self];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    
}

@end
