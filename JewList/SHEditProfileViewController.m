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
#import "SHWorkPartyCell.h"
#import "SHWorkPartyViewController.h"
#import "SHCleanMessyViewController.h"
#import "SHCleanMessyCell.h"
#import "SHDietViewController.h"
#import "SHDietCell.h"
#import "SHShabatCell.h"
#import "SHShabbatViewController.h"
#import "SHWhatIWantInARoomateViewController.h"
#import "SHRoomatePrefCell.h"
#import "SHCampusViewController.h"
#import "SHLocationCell.h"
#import "SHAgeViewController.h"
#import "SHAgeCell.h"

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
    [_tableView registerClass:[SHWorkPartyCell class] forCellReuseIdentifier:NSStringFromClass([SHWorkPartyCell class])];
    [_tableView registerClass:[SHCleanMessyCell class] forCellReuseIdentifier:NSStringFromClass([SHCleanMessyCell class])];
    [_tableView registerClass:[SHDietCell class] forCellReuseIdentifier:NSStringFromClass([SHDietCell class])];
    [_tableView registerClass:[SHShabatCell class] forCellReuseIdentifier:NSStringFromClass([SHShabatCell class])];
    [_tableView registerClass:[SHRoomatePrefCell class] forCellReuseIdentifier:NSStringFromClass([SHRoomatePrefCell class])];
    [_tableView registerClass:[SHLocationCell class] forCellReuseIdentifier:NSStringFromClass([SHLocationCell class])];
    [_tableView registerClass:[SHAgeCell class] forCellReuseIdentifier:NSStringFromClass([SHAgeCell class])];

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
    [[SHApi sharedInstance] setCurrentUser:_currentUser];
    [self closeVC];
    
}

- (void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if(section == 0)
    {
        count = 5;
    }else if(section == 1)
    {
        count = 1;
    }
    else if(section == 2)
    {
        count = 5;
    }
    
    return count;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if(section == 0)
    {
        title = @"Personal Info";
    }else if(section == 1)
    {
        title = @"Location";
    }
    else if(section == 2)
    {
        title = @"Lifestyle";
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
        cellHeight = (row == 0 || row == 1 || row == 2) ? [SHPersonalInfoCell rowHeight] : [SHTextItemCell rowHeight];
        
    }else if(section == 1)
    {
        cellHeight = [SHLocationCell rowHeight];
        
    }
    else if(section == 2)
    {
        cellHeight = [SHWorkPartyCell rowHeight];
        
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
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHAgeCell class])];
                SHAgeCell *genderCell = (SHAgeCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHGenderCell class])];
                SHGenderCell *genderCell = (SHGenderCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHHighSchoolInfoCell class])];
                SHHighSchoolInfoCell *genderCell = (SHHighSchoolInfoCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            case 4:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHAboutMeCell class])];
                SHAboutMeCell *genderCell = (SHAboutMeCell *)cell;
                genderCell.user = _currentUser;
                break;
            }
            default:
                break;
        }
    }else if(section == 1)
    {
        switch (row) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHLocationCell class])];
                SHLocationCell *gradCell = (SHLocationCell *)cell;
                gradCell.user = _currentUser;
                
                break;
            }

            default:
                break;

        }
    }
    else if(section == 2)
    {
        switch (row) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHRoomatePrefCell class])];
                SHRoomatePrefCell *gradCell = (SHRoomatePrefCell *)cell;
                gradCell.user = _currentUser;
                
                break;
            }
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHWorkPartyCell class])];
                SHWorkPartyCell *gradCell = (SHWorkPartyCell *)cell;
                gradCell.user = _currentUser;
                
                break;
            }
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHCleanMessyCell class])];
                SHCleanMessyCell *gradCell = (SHCleanMessyCell *)cell;
                gradCell.user = _currentUser;

                break;
            }
            case 3:
            {

                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHDietCell class])];
                SHDietCell *gradCell = (SHDietCell *)cell;
                gradCell.user = _currentUser;
                break;
            }
            case 4:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHShabatCell class])];
                SHShabatCell *gradCell = (SHShabatCell *)cell;
                gradCell.user = _currentUser;

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
                SHAgeViewController *vc = [[SHAgeViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                SHGenderViewController *vc = [[SHGenderViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                SHHSEngadmentViewController *vc = [[SHHSEngadmentViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 4:
            {
                SHAboutMeViewController *vc = [[SHAboutMeViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
    }else if(section == 1)
    {
        switch (row) {
            case 0:
            {
                SHCampusViewController *vc = [[SHCampusViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                
                break;
            }
            
            default:
                break;
        }

    }else if(section == 2)
    {
        switch (row) {
            case 0:
            {
                SHWhatIWantInARoomateViewController *vc = [[SHWhatIWantInARoomateViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                
                break;
            }
            case 1:
            {
                SHWorkPartyViewController *vc = [[SHWorkPartyViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                
                break;
            }
            case 2:
            {
                SHCleanMessyViewController *vc = [[SHCleanMessyViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                SHDietViewController *vc = [[SHDietViewController alloc] initWithUser:_currentUser];
                [self.navigationController  pushViewController:vc animated:YES];
                break;
            }
            case 4:
            {
                SHShabbatViewController *vc = [[SHShabbatViewController alloc] initWithUser:_currentUser];
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
