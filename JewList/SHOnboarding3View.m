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
    self.backgroundColor = [UIColor whiteColor];
    
    self.topResultsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
    _topResultsBgView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_topResultsBgView];

    self.somePotentialResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _topResultsBgView.width - 20, 40)];
    _somePotentialResultsLabel.textAlignment = NSTextAlignmentCenter;
    _somePotentialResultsLabel.font = [UIFont fontWithName:DEFAULT_FONT size:(_somePotentialResultsLabel.height/2)-4];
    _somePotentialResultsLabel.centerX = floorf(_topResultsBgView.width/2);
    _somePotentialResultsLabel.centerY = floorf(_topResultsBgView.height/2);
    _somePotentialResultsLabel.textColor = [UIColor whiteColor];
    _somePotentialResultsLabel.backgroundColor = [UIColor grayColor];
    _somePotentialResultsLabel.adjustsFontSizeToFitWidth = YES;
    _somePotentialResultsLabel.text = @"Mazal Tov! here are some potential roomies for you";
    [self addSubview:_somePotentialResultsLabel];
 
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _nextStepButton.backgroundColor = [UIColor blueColor];
    _nextStepButton.bottom = self.height - 5;
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateHighlighted];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = _topResultsBgView.centerX;
    [self addSubview:_nextStepButton];  

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _somePotentialResultsLabel.bottom, self.width,_nextStepButton.top - _somePotentialResultsLabel.bottom) style:UITableViewStylePlain];
    
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
        [self.tableView registerClass:[UserResultCell class] forCellReuseIdentifier:NSStringFromClass([UserResultCell class])];
    
    [self addSubview:self.tableView];
    
}

#pragma mark == UITableView Delegate ==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserResultCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserResultCell class])];
    
    if(!IS_IOS6)
    {
        if(nil == cell)
        {
            cell = [[UserResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UserResultCell class])];
        }
    }
    
    User *item = [_items objectAtIndex:indexPath.row];
    cell.user = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *item = [_items objectAtIndex:indexPath.row];
    
    
}



@end
