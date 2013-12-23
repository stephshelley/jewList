//
//  SHEditProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHEditProfileViewController.h"
#import "SHGenderCell.h"
#import "SHGraduationYearCell.h"
#import "SHApi.h"
#import "SHGradYearViewController.h"
#import "SHGenderViewController.h"
#import "SHAboutMeCell.h"
#import "SHHighSchoolInfoCell.h"
#import "SHHSEngadmentViewController.h"
#import "SHAboutMeViewController.h"

@interface SHEditProfileViewController ()

@end

@implementation SHEditProfileViewController

- (id)initWithUser:(User *)currentUser
{
    self = [super init];
    if(self)
    {
        _currentUser = currentUser;
        
    }
    
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.title = @"Edit Profile";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProfile)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44 - (IS_IOS7 ? 20 : 0)) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[SHGenderCell class] forCellReuseIdentifier:NSStringFromClass([SHGenderCell class])];
    [_tableView registerClass:[SHGraduationYearCell class] forCellReuseIdentifier:NSStringFromClass([SHGraduationYearCell class])];
    [_tableView registerClass:[SHAboutMeCell class] forCellReuseIdentifier:NSStringFromClass([SHAboutMeCell class])];
    [_tableView registerClass:[SHHighSchoolInfoCell class] forCellReuseIdentifier:NSStringFromClass([SHHighSchoolInfoCell class])];

    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Edit Profile";

    [_tableView reloadData];
}

- (void)saveProfile
{
    [self closeVC];
    
}

- (void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if(section == 0)
    {
        title = @"Personal Info";
    }
    
    return title;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    CGFloat cellHeight = 0;
    
    if(section == 0)
    {
        cellHeight = (row == 0 || row == 1) ? [SHPersonalInfoCell rowHeight] : [SHTextItemCell rowHeight];
        
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    
    if(section == 0)
    {
        switch (row) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHGraduationYearCell class])];
                SHGraduationYearCell *gradCell = (SHGraduationYearCell *)cell;
                gradCell.user = _currentUser;
                
                break;
            }
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHGenderCell class])];
                SHGenderCell *genderCell = (SHGenderCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHHighSchoolInfoCell class])];
                SHHighSchoolInfoCell *genderCell = (SHHighSchoolInfoCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHAboutMeCell class])];
                SHAboutMeCell *genderCell = (SHAboutMeCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            default:
                break;
        }
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;

    if(section == 0)
    {
        switch (row) {
            case 0:
            {
                SHGradYearViewController *vc = [[SHGradYearViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                
                break;
            }
            case 1:
            {
                SHGenderViewController *vc = [[SHGenderViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                SHHSEngadmentViewController *vc = [[SHHSEngadmentViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                SHAboutMeViewController *vc = [[SHAboutMeViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
