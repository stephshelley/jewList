//
//  SHOnboarding3View.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHOnboarding3View.h"
#import "User.h"
#import "UserResultCell.h"
#import "SHProfileViewController.h"
#import "UIView+FindUIViewController.h"
#import "JLColors.h"
#import "SHUserCellItem.h"

@implementation SHOnboarding3View

- (id)initWithFrame:(CGRect)frame andUser:(User*)user
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.user = user;
        
        [self loadUI];
        
    }
    
    return self;
    
}

- (void)loadUI
{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 5)];
    progressBar.backgroundColor = [UIColor JLGreen];
    UIView *progressMade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, progressBar.width , progressBar.height)];
    progressMade.backgroundColor = [UIColor JLDarkGreen];
    [progressBar addSubview:progressMade];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:progressBar.frame];
    progressLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.text = @"Sucess!";
    progressLabel.centerY = floorf(progressBar.height/2);
    //[progressBar addSubview:progressLabel];
    [self addSubview:progressBar];
    
    self.topResultsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, progressBar.bottom, self.width, 50)];
    _topResultsBgView.backgroundColor = [UIColor JLGrey];
    [self addSubview:_topResultsBgView];
        
    self.somePotentialResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _topResultsBgView.top, _topResultsBgView.width - 20, _topResultsBgView.height)];
    _somePotentialResultsLabel.textAlignment = NSTextAlignmentCenter;
    _somePotentialResultsLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _somePotentialResultsLabel.textColor = [UIColor whiteColor];
    _somePotentialResultsLabel.backgroundColor = [UIColor JLGrey];
    _somePotentialResultsLabel.adjustsFontSizeToFitWidth = YES;
    _somePotentialResultsLabel.text = @"Here are some potential roomates from your college.";
    [self addSubview:_somePotentialResultsLabel];
    
    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-buttonHeight, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_nextStepButton setTitle:@"Let's finish your profile" forState:UIControlStateNormal];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.bottom = self.height + 40;
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nextStepButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _somePotentialResultsLabel.bottom, self.width,_nextStepButton.top - _somePotentialResultsLabel.bottom) style:UITableViewStylePlain];
    
    if(!IsIpad)
    {
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UserResultCell class] forCellReuseIdentifier:NSStringFromClass([UserResultCell class])];
    
    [self addSubview:self.tableView];
    [self.dataSource loadModel];
    
}

- (SHMemberResultsDataSource *)dataSource
{
    if(_dataSource == nil)
    {
        _dataSource = [[SHMemberResultsDataSource alloc] initWithCollege:_user.college];
        _dataSource.delegate = self;
    }
    
    return _dataSource;
    
}

#pragma mark - STBaseDataSource Delegate -

- (void)dataSourceLoaded:(id)dataSource
{
    
    [_tableView reloadData];

}

- (void)dataSourceError:(NSError *)error
{
    
}



- (void)loadTestData
{
    _items = nil;
    _items = [NSMutableArray array];
    
    for(int i = 0; i < 10; i++)
    {
        [_items addObject:_user];
        
    }
    
    [_tableView reloadData];
}

#pragma mark == UITableView Delegate ==

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
    SHUserCellItem *item = [_dataSource.items objectAtIndex:indexPath.row];
    cell.user = item.user;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHUserCellItem *item = [_dataSource.items objectAtIndex:indexPath.row];
    SHProfileViewController *userVC = [[SHProfileViewController alloc] initWithUser:item.user];
    [[[self firstAvailableUIViewController] navigationController] pushViewController:userVC animated:YES];
    
}



@end
