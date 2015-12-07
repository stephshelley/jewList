//
//  MultiSelectionPresenter.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "MultiSelectionPresenter.h"
#import "MultiSelectionViewController.h"
#import "MultiSelectionHelpers.h"
#import "AppDelegate.h"

@interface MultiSelectionPresenter () <MultiSelectionViewControllerDelegate>

@property (nonatomic) UIViewController *currentViewController;
@property (nonatomic) User *user;

@end

@implementation MultiSelectionPresenter

+ (instancetype)presenterFromViewController:(UIViewController *)fromViewController user:(User *)user {
    MultiSelectionPresenter *presenter = [MultiSelectionPresenter new];
    presenter.currentViewController = fromViewController;
    presenter.user = user;
    return presenter;
}

- (void)present {
    MultiSelectionViewController *multiVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"MultiSelectionViewController"];
    multiVC.type = MultiSelectionTypeGender;
    multiVC.delegate = self;
    [self.currentViewController.navigationController pushViewController:multiVC animated:YES];
}

#pragma mark - MultiSelectionViewControllerDelegate -

- (void)mutliSelectionViewControllerDidSelect:(MultiSelectionViewController *)viewController value:(NSString *)value {
    [MultiSelectionHelpers setUserValue:value type:viewController.type user:self.user];
    MultiSelectionViewController *multiVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"MultiSelectionViewController"];
    multiVC.type = viewController.type + 1;
    multiVC.delegate = self;
    [self.currentViewController.navigationController pushViewController:multiVC animated:YES];
}

@end
