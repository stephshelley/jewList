//
//  EditProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/26/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileDetailCellItem.h"
#import "ProfileDetailCell.h"
#import "User.h"
#import "SHApi.h"
#import "MultiSelectionHelpers.h"
#import "FreeTextHelpers.h"
#import "AppDelegate.h"
#import "SHUIHelpers.h"
#import "MultiSelectionViewController.h"
#import "FreeTextViewController.h"
#import "AgeViewController.h"
#import "CollegeViewController.h"
#import "GraduationYearViewController.h"
#import "DeleteAccountCellItem.h"
#import "DeleteAccountCell.h"

NSString * const graduationTitle = @"Graduation Year";
NSString * const schoolTitle = @"School";
NSString * const ageTitle = @"Age";
NSString * const yesTitle = @"Yes";

@interface EditProfileViewController () <MultiSelectionViewControllerDelegate, FreeTextViewControllerDelegate, CollegeViewControllerDelegate, GraduationYearViewControllerDelegate , AgeViewControllerDelegate>

@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *items;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(ProfileDetailCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(ProfileDetailCell.class)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(DeleteAccountCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(DeleteAccountCell.class)];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    [self loadItems];
    [self.tableView reloadData];
}

- (void)loadItems
{
    self.currentUser = [[SHApi sharedInstance] currentUser];
    self.items = [NSMutableArray array];
    ProfileDetailCellItem *schoolItem = [ProfileDetailCellItem new];
    schoolItem.title = schoolTitle;
    schoolItem.detail = self.currentUser.college.collegeName;
    [self.items addObject:schoolItem];
    
    ProfileDetailCellItem *graduationItem = [ProfileDetailCellItem new];
    graduationItem.title = graduationTitle;
    graduationItem.detail = self.currentUser.gradYear;
    [self.items addObject:graduationItem];

    ProfileDetailCellItem *ageItem = [ProfileDetailCellItem new];
    ageItem.title = ageTitle;
    ageItem.detail = (NSString *)self.currentUser.age;
    [self.items addObject:ageItem];

    ProfileDetailCellItem *aboutMeItem = [ProfileDetailCellItem new];
    aboutMeItem.title = @"About Me";
    aboutMeItem.detail = self.currentUser.aboutMe;
    aboutMeItem.freeTextType = FreeTextTypeAboutMe;
    [self.items addObject:aboutMeItem];

    ProfileDetailCellItem *majorItem = [ProfileDetailCellItem new];
    majorItem.title = @"Desired Major";
    majorItem.detail = self.currentUser.desiredMajor;
    majorItem.freeTextType = FreeTextTypeDesiredMajor;
    [self.items addObject:majorItem];
    
    for (NSUInteger index = MultiSelectionTypeGender; index <= MultiSelectionTypeWantContactFromJewishOrganizations; index ++) {
        
        ProfileDetailCellItem *item = [ProfileDetailCellItem new];
        item.title = [MultiSelectionHelpers questionTitleForType:index];
        item.detail = [MultiSelectionHelpers userValueForType:index user:self.currentUser];
        item.multiSelectionType = index;
        
        if (item.detail.length == 0) {
            item.detail = @"Press to edit";
        }
        
        [self.items addObject:item];
    }
    
    [self.items addObject:[DeleteAccountCellItem new]];
}

- (IBAction)onCancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onLogoutButton:(id)sender {
    
   UIAlertController *controller = [SHUIHelpers alertControllerWithTitle:@"Logout" message:@"Are you sure you want to logout?" buttonTitles:@[yesTitle] completion:^(NSString *selectedButtonTitle) {
       
       if ([selectedButtonTitle isEqualToString:yesTitle]) {
           [[SHApi sharedInstance] logout];
       }
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    
    if ([object isKindOfClass:[ProfileDetailCellItem class]]) {
        ProfileDetailCellItem *item = (ProfileDetailCellItem *)object;
        cell = (ProfileDetailCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ProfileDetailCell.class) forIndexPath:indexPath];
        [(ProfileDetailCell *)cell setItem:item];
    } else if ([object isKindOfClass:[DeleteAccountCellItem class]]) {
        cell = (DeleteAccountCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DeleteAccountCell.class) forIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileDetailCellItem *item = [self.items objectAtIndex:indexPath.row];
    if (![item isKindOfClass:[ProfileDetailCellItem class]]) return;
    
    UIViewController *vc = nil;
    if ([item.title isEqualToString:graduationTitle]) {
        GraduationYearViewController *gradVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"GraduationYearViewController"];
        gradVC.saveOnBackButton = YES;
        gradVC.delegate = self;
        gradVC.user = self.currentUser;
        vc = gradVC;
    }else if ([item.title isEqualToString:ageTitle]) {
        AgeViewController *ageVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"AgeViewController"];
        ageVC.saveOnBackButton = YES;
        ageVC.delegate = self;
        ageVC.user = self.currentUser;
        vc = ageVC;
    } else if ([item.title isEqualToString:schoolTitle]) {
        CollegeViewController *collegeVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"CollegeViewController"];
        collegeVC.saveOnBackButton = YES;
        collegeVC.delegate = self;
        vc = collegeVC;
    } else if (item.freeTextType > 0) {
        FreeTextViewController *freeTextVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"FreeTextViewController"];
        freeTextVC.saveOnBackButton = YES;
        freeTextVC.type = item.freeTextType;
        freeTextVC.preloadText = item.detail;
        freeTextVC.delegate = self;
        vc = freeTextVC;
    } else if (item.multiSelectionType > 0) {
        MultiSelectionViewController *multiSelectionVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"MultiSelectionViewController"];
        multiSelectionVC.saveOnBackButton = YES;
        multiSelectionVC.user = self.currentUser;
        multiSelectionVC.type = item.multiSelectionType;
        multiSelectionVC.delegate = self;
        vc = multiSelectionVC;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveUserAndUpdate {
    [[SHApi sharedInstance] setCurrentUser:self.currentUser];
    [[SHApi sharedInstance] updateUser:self.currentUser success:nil failure:nil];
    [self loadItems];
    [self.tableView reloadData];
}

#pragma mark - MultiSelectionViewControllerDelegate

- (void)mutliSelectionViewControllerDidSelect:(MultiSelectionViewController *)viewController value:(NSString *)value {
    [MultiSelectionHelpers setUserValue:value type:viewController.type user:self.currentUser];
    [self saveUserAndUpdate];
}

#pragma mark - MultiSelectionViewControllerDelegate

- (void)freeTextControllerDidChooseText:(FreeTextViewController *)viewController text:(NSString *)text {
    [FreeTextHelpers setUserValue:text type:viewController.type user:self.currentUser];
    [self saveUserAndUpdate];
}

#pragma mark - CollegeViewControllerDelegate

- (void)collegeViewControllerDidSelectCollege:(College *)college {
    self.currentUser.school = college.collegeName;
    self.currentUser.college = college;
    [self saveUserAndUpdate];
}

#pragma mark - GraduationYearViewControllerDelegate

- (void)graduationYearViewControllerDidSelectYear:(NSNumber *)year {
    self.currentUser.gradYear = [year stringValue];
    [self saveUserAndUpdate];
}

#pragma mark - AgeViewControllerDelegate

- (void)graduationYearViewControllerDidSelectAge:(NSString *)age {
    self.currentUser.age = age;
    [self saveUserAndUpdate];
}

@end
