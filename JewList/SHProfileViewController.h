//
//  SHProfileViewController.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "NINetworkImageView.h"

@class User;

@interface SHProfileViewController : UIViewController

@property (nonatomic, strong) NINetworkImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) User *user;

- (id)initWithUser:(User*)user;

@end
