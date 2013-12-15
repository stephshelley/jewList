//
//  SHOnboardingStep2View.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOnboardingDelegate.h"
@class User;

@interface SHOnboarding2View : UIView <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFiltering;
    UIControl *_searchOverlay;

}

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSMutableArray *fullCollegesArray;
@property (nonatomic, strong) NSMutableArray *filteredCollegesArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UILabel *collegeLabel;
@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UIView *collegeTopView;

@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) id fetchCollegesRequest;
@property (nonatomic, assign) id<SHOnboardingDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;
- (void)loadTable;
- (void)reloadTable;

@end
