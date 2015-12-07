//
//  WelcomeViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "WelcomeViewController.h"
#import "NINetworkImageView.h"
#import "SHUIHelpers.h"
#import "SHApi.h"
#import "CollegeViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hiLabel;
@property (weak, nonatomic) IBOutlet NINetworkImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *hometownTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Welcome";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.hidesBackButton = YES;
    self.hiLabel.text = [NSString stringWithFormat:@"Hi %@!",self.user.firstName];
    self.nameTextField.text = [NSString stringWithFormat:@"%@ %@",self.user.firstName, self.user.lastName];
    self.emailTextField.text = self.user.email;
    self.hometownTextField.text = [NSString stringWithFormat:@"%@",self.user.fbHometownName];
    [self.userImageView setUserImagePathToNetworkImage:[self.user fbImageUrlForSize:self.userImageView.size] forDisplaySize:self.userImageView.size contentMode:UIViewContentModeScaleAspectFill];

}

- (IBAction)onNextButton:(id)sender {
    if(self.nameTextField.text.length == 0)
    {
        [SHUIHelpers alertErrorWithMessage:@"Please enter a name"];
        return;
    }
    
    if(self.emailTextField.text.length == 0)
    {
        [SHUIHelpers alertErrorWithMessage:@"Please enter an email address"];
        return;
    }
    
    User *currentUser = [[SHApi sharedInstance] currentUser];
    
    NSArray *nameArray = [self.nameTextField.text componentsSeparatedByString:@" "];
    if(nameArray.count > 0)
    {
        currentUser.firstName = [nameArray firstObject];
    }
    
    if(nameArray.count > 1)
    {
        currentUser.lastName = [[nameArray subarrayWithRange:NSMakeRange(1, nameArray.count - 1)] componentsJoinedByString:@" "];
    }
    
    currentUser.fbHometownName = self.hometownTextField.text;
    [[SHApi sharedInstance] setCurrentUser:currentUser];
    
    CollegeViewController *collegeViewController = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"CollegeViewController"];
    collegeViewController.user = [[SHApi sharedInstance] currentUser];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController pushViewController:collegeViewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    }else if (textField == self.emailTextField) {
        [self.hometownTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
