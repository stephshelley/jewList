//
//  AgeViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol AgeViewControllerDelegate;

@interface AgeViewController : UIViewController

@property (nonatomic) User *user;
@property (nonatomic) BOOL saveOnBackButton;
@property (nonatomic) id<AgeViewControllerDelegate> delegate;

@end

@protocol AgeViewControllerDelegate <NSObject>

@optional
- (void)graduationYearViewControllerDidSelectAge:(NSString *)age;

@end