//
//  SHGenderViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHGenderViewController.h"
#import "JLColors.h"

#define TAG_MALE_BUTTON 0
#define TAG_FEMALE_BUTTON 1

@interface SHGenderViewController ()

@end

@implementation SHGenderViewController

- (id)initWithUser:(User *)currentUser
{
    self = [super init];
    if(self)
    {
        _currentUser = currentUser;
        
    }
    
    return self;
    
}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DEFAULT_BLUE_COLOR;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:topView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popVC)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(topView.height/2);
    leftButtonView.left = 0;
    [topView addSubview:leftButtonView];
    CGFloat buttonHeight = 120;
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, self.view.height-topView.height)];
    whiteBgView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self.view addSubview:whiteBgView];

    UIView *headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, 50)];
    headerTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerTopView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerTopView.width - 20, headerTopView.height)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    headerLabel.textColor = DEFAULT_BLUE_COLOR;
    headerLabel.adjustsFontSizeToFitWidth = YES;
    headerLabel.text = @"Are you male or female?";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.centerX = floorf(headerTopView.width/2);
    [headerTopView addSubview:headerLabel];
    
    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    genderBackgroundView.backgroundColor = [UIColor clearColor];
    genderBackgroundView.center = self.view.center;
    [self.view addSubview:genderBackgroundView];
    
    buttonHeight = 110;
    self.femaleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(0, 0, buttonHeight, buttonHeight)];
    //[_femaleButton setTitle:@"Female" forState:UIControlStateNormal];
    //[_femaleButton setTitle:@"Female" forState:UIControlStateHighlighted];
    _femaleButton.colorOn = [UIColor clearColor];
    _femaleButton.colorOff = [UIColor clearColor];
    _femaleButton.tag = TAG_FEMALE_BUTTON;
    _femaleButton.top = 30;
    _femaleButton.onImage = @"female_s";
    _femaleButton.offImage = @"female_d";
    _femaleButton.right = floor(genderBackgroundView.width/2);
    _femaleButton.centerY = floorf(genderBackgroundView.height/2);
    [_femaleButton toggle:NO]; // OFF
    [_femaleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_femaleButton];
    
    
    self.maleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_femaleButton.right +2, _femaleButton.top, _femaleButton.width, _femaleButton.height)];
    //[_maleButton setTitle:@"Male" forState:UIControlStateNormal];
    //[_maleButton setTitle:@"Male" forState:UIControlStateHighlighted];
    _maleButton.colorOn = [UIColor clearColor];
    _maleButton.colorOff = [UIColor clearColor];
    _maleButton.tag = TAG_MALE_BUTTON;
    _maleButton.top = _femaleButton.top;
    _maleButton.left = _femaleButton.right+1;
    _maleButton.onImage = @"male_s";
    _maleButton.offImage = @"male_d";
    [_maleButton toggle:NO]; // OFF
    [_maleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_maleButton];
    
    [self setGender];
    
}

- (void)genderTogglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == TAG_FEMALE_BUTTON && [senderButton isOn])
    {
        [_maleButton toggle:NO];
        _maleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _femaleButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.gender = @1;
    }
    else if(senderButton.tag == TAG_MALE_BUTTON && [senderButton isOn])
    {
        [_femaleButton toggle:NO];
        _femaleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _maleButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.gender = @0;
    }
    

}

- (void)setGender
{
    if([_currentUser.gender intValue] == 1)
    {
        [_maleButton toggle:NO];
        [_femaleButton toggle:YES];
        _maleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _femaleButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.gender = @1;//female
        
    }else if([_currentUser.gender intValue] == 0)
    {
        [_femaleButton toggle:NO];
        [_maleButton toggle:YES];
        _femaleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _maleButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.gender = @0; // male
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
