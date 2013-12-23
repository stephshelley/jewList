//
//  SHTextEditViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@interface SHTextEditViewController : UIViewController

@property (nonatomic, strong) UIView *headerTopView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) User *currentUser;

- (id)initWithUser:(User *)currentUser;

@end
