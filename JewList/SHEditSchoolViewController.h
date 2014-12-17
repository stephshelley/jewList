//
//  SHEditSchoolViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/16/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOnboarding2View.h"
#import "User.h"

@interface SHEditSchoolViewController : UIViewController

@property (nonatomic ,strong) SHOnboarding2View *schoolView;
@property (nonatomic, strong) User *user;

- (id)initWithUser:(User *)user;

@end
