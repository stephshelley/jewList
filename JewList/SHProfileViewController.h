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
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *kosherStaticLabel;
@property (nonatomic, strong) UILabel *kosherLabel;
@property (nonatomic, strong) UIImageView *kosherImageView;

@property (nonatomic, strong) UILabel *shabatStaticLabel;
@property (nonatomic, strong) UILabel *shabatLabel;
@property (nonatomic, strong) UIImageView *shabatImageView;

@property (nonatomic, strong) UILabel *facebookStaticLabel;
@property (nonatomic, strong) UIButton *facebookButton;

@property (nonatomic, strong) User *user;

- (id)initWithUser:(User*)user;

@end
