//
//  ResultsViewController.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMemberResultsDataSource.h"
#import "MNMPullToRefreshManager.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,STBaseDataSource,MNMPullToRefreshManagerClient>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) SHMemberResultsDataSource *dataSource;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *emptyResultsLabel;
@property (nonatomic, strong) UIView *topResultsBgView;
@property (nonatomic, strong) MNMPullToRefreshManager *pullToRefreshManager;


@end
