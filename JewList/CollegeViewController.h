//
//  CollegeViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "College.h"

@protocol CollegeViewControllerDelegate;

@interface CollegeViewController : UIViewController

@property (nonatomic) User *user;
@property (nonatomic) BOOL saveOnBackButton;
@property (nonatomic) id<CollegeViewControllerDelegate> delegate;

@end

@protocol CollegeViewControllerDelegate <NSObject>

- (void)collegeViewControllerDidSelectCollege:(College *)college;

@end