//
//  FreeTextPresenter.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "FreeTextPresenter.h"
#import "FreeTextViewController.h"
#import "FreeTextHelpers.h"
#import "AppDelegate.h"
#import "SHApi.h"
#import "SHUIHelpers.h"
#import "ResultsViewController.h"

@interface FreeTextPresenter () <FreeTextViewControllerDeleage>

@property (nonatomic) UIViewController *currentViewController;
@property (nonatomic) User *user;

@end

@implementation FreeTextPresenter

+ (instancetype)presenterFromViewController:(UIViewController *)fromViewController user:(User *)user {
    FreeTextPresenter *presenter = [FreeTextPresenter new];
    presenter.currentViewController = fromViewController;
    presenter.user = user;
    return presenter;
}

- (void)present {
    FreeTextViewController *freeTextVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"FreeTextViewController"];
    freeTextVC.type = FreeTextTypeAboutMe;
    freeTextVC.delegate = self;
    [self.currentViewController.navigationController pushViewController:freeTextVC animated:YES];
}

#pragma mark - MultiSelectionViewControllerDelegate -

- (void)freeTextControllerDidChooseText:(FreeTextViewController *)viewController text:(NSString *)text {
    [FreeTextHelpers setUserValue:text type:viewController.type user:self.user];
    if (viewController.type == FreeTextTypeDesiredMajor) {
        [[SHApi sharedInstance] updateUser:self.user success:^(User *updatedUser){
            dispatch_async(dispatch_get_main_queue(), ^{
                ResultsViewController *vc = [[ResultsViewController alloc] init];
                [viewController.navigationController pushViewController:vc animated:NO];
            });
        }failure:^(NSError *error)
         {
             [SHUIHelpers alertErrorWithMessage:@"We're sorry, we counldnt finish the signup process, please try again."];
         }];
        
    } else {
        FreeTextViewController *multiVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"FreeTextViewController"];
        multiVC.type = viewController.type + 1;
        multiVC.delegate = self;
        [self.currentViewController.navigationController pushViewController:multiVC animated:YES];
    }
}

@end
