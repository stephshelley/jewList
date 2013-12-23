//
//  SHGenderViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "SHToggleButton.h"

@interface SHGenderViewController : UIViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) SHToggleButton *maleButton;
@property (nonatomic, strong) SHToggleButton *femaleButton;

- (id)initWithUser:(User *)currentUser;


@end
