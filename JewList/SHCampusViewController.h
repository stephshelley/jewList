//
//  SHCampusViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "SHToggleButton.h"

@interface SHCampusViewController : UIViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) SHToggleButton *onCampusButton;
@property (nonatomic, strong) SHToggleButton *offCampusButton;

- (id)initWithUser:(User *)currentUser;

@end
