//
//  SHOnboarding3View.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMemberResultsDataSource.h"

@class User;

@interface SHOnboarding3View : UIView <UITableViewDataSource,UITableViewDelegate,STBaseDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *somePotentialResultsLabel;
@property (nonatomic, strong) UIView *topResultsBgView;
@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UIButton *nextStepButton;
@property (nonatomic, strong) SHMemberResultsDataSource *dataSource;

- (id)initWithFrame:(CGRect)frame andUser:(User*)user;

@end
