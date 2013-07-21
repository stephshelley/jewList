//
//  SHProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHProfileViewController.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import "SHUIHelpers.h"

@implementation SHProfileViewController

- (id)initWithUser:(User*)user
{
    self = [super init];
    if(self)
    {
        self.user = user;
    }
    
    return self;
    
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Profile";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];

    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButtonView]];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 40,24)];
    _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.centerX = floorf(self.view.width/2);
    _nameLabel.top = 20;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
    [self.view addSubview:_nameLabel];
    
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _userImageView.centerX = _nameLabel.centerX;
    _userImageView.top = _nameLabel.bottom + 10;
    _userImageView.backgroundColor = [UIColor redColor];
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImageView.layer.borderWidth = 2.0;
    [self.view addSubview:_userImageView];

    [_userImageView setPathToNetworkImage:_user.fbImageUrl forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _nameLabel.width,20)];
    _detailLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_detailLabel.height-2)];
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.centerX = _nameLabel.centerX;
    _detailLabel.top = _userImageView.bottom + 10;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = [NSString stringWithFormat:@"%@, %@, %@",[self getGenderSign],SAFE_VAL(_user.age) ,_user.fbHometownName];
    [self.view addSubview:_detailLabel];

    [self loadUserDetails];
    
}

- (void)loadUserDetails
{
    UIView *detailsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _detailLabel.bottom + 10, self.view.width, self.view.height - (_detailLabel.bottom + 54))];
    detailsBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailsBackgroundView];
    
    self.kosherStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,80,17)];
    _kosherStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_kosherStaticLabel.height-2)];
    _kosherStaticLabel.textColor = [UIColor blackColor];
    _kosherStaticLabel.centerX = 53;
    _kosherStaticLabel.top = 20;
    _kosherStaticLabel.adjustsFontSizeToFitWidth = YES;
    _kosherStaticLabel.backgroundColor = [UIColor clearColor];
    _kosherStaticLabel.textAlignment = NSTextAlignmentCenter;
    _kosherStaticLabel.text = @"Kosher";
    [detailsBackgroundView addSubview:_kosherStaticLabel];
    
    self.kosherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _kosherImageView.backgroundColor = [UIColor redColor];
    _kosherImageView.top = _kosherStaticLabel.bottom + 10;
    _kosherImageView.centerX = _kosherStaticLabel.centerX;
    [detailsBackgroundView addSubview:_kosherImageView];
    
    self.kosherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _kosherLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_kosherLabel.height-2)];
    _kosherLabel.textColor = [UIColor blackColor];
    _kosherLabel.centerX = _kosherImageView.centerX;
    _kosherLabel.top = _kosherImageView.bottom + 10;
    _kosherLabel.adjustsFontSizeToFitWidth = YES;
    _kosherLabel.backgroundColor = [UIColor clearColor];
    _kosherLabel.textAlignment = NSTextAlignmentCenter;
    _kosherLabel.text = _user.kosher;
    [detailsBackgroundView addSubview:_kosherLabel];
    
    
    
    
    self.shabatStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,80,17)];
    _shabatStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_shabatStaticLabel.height-2)];
    _shabatStaticLabel.textColor = [UIColor blackColor];
    _shabatStaticLabel.centerX = floor(self.view.width/2);
    _shabatStaticLabel.top = _kosherStaticLabel.top;
    _shabatStaticLabel.adjustsFontSizeToFitWidth = YES;
    _shabatStaticLabel.backgroundColor = [UIColor clearColor];
    _shabatStaticLabel.textAlignment = NSTextAlignmentCenter;
    _shabatStaticLabel.text = @"Shabat";
    [detailsBackgroundView addSubview:_shabatStaticLabel];
    
    self.shabatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _shabatImageView.backgroundColor = [UIColor redColor];
    _shabatImageView.top = _shabatStaticLabel.bottom + 10;
    _shabatImageView.centerX = _shabatStaticLabel.centerX;
    [detailsBackgroundView addSubview:_shabatImageView];
    
    self.shabatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _shabatLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_shabatLabel.height-2)];
    _shabatLabel.textColor = [UIColor blackColor];
    _kosherLabel.centerX = _shabatImageView.centerX;
    _shabatLabel.top = _shabatImageView.bottom + 10;
    _shabatLabel.adjustsFontSizeToFitWidth = YES;
    _shabatLabel.backgroundColor = [UIColor clearColor];
    _shabatLabel.textAlignment = NSTextAlignmentCenter;
    _shabatLabel.text = _user.shabat;
    [detailsBackgroundView addSubview:_shabatLabel];
        
    

    self.facebookStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _facebookStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_facebookStaticLabel.height-2)];
    _facebookStaticLabel.textColor = [UIColor blackColor];
    _facebookStaticLabel.centerX = 266;
    _facebookStaticLabel.top = _shabatStaticLabel.top;
    _facebookStaticLabel.adjustsFontSizeToFitWidth = YES;
    _facebookStaticLabel.backgroundColor = [UIColor clearColor];
    _facebookStaticLabel.textAlignment = NSTextAlignmentCenter;
    _facebookStaticLabel.text = @"Facebook Profile";
    [detailsBackgroundView addSubview:_facebookStaticLabel];
    
    self.facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _facebookButton.backgroundColor = DEFAULT_BLUE_COLOR;
    _facebookButton.centerY = _shabatImageView.centerY;
    _facebookButton.centerX = _facebookStaticLabel.centerX;
    [_facebookButton addTarget:self action:@selector(facebookButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [detailsBackgroundView addSubview:_facebookButton];

}

- (void)facebookButtonPressed
{
    
}

- (NSString*)getGenderSign
{
    NSString *gender = nil;
    
    if([_user.gendre isEqualToString:@"male"])
    {
        gender = @"M";
    }else if([_user.gendre isEqualToString:@"female"])
    {
        gender = @"F";
    }else{
        gender = @"";
    }
    
    return gender;
}


- (void)popScreen
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
