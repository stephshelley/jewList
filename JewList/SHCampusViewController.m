//
//  SHCampusViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHCampusViewController.h"
#import "JLColors.h"

#define ON_BUTTON 0
#define OFF_BUTTON 1


@interface SHCampusViewController ()

@end

@implementation SHCampusViewController

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
    headerLabel.text = @"Do you live on/off campus?";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.centerX = floorf(headerTopView.width/2);
    [headerTopView addSubview:headerLabel];

    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    genderBackgroundView.backgroundColor = [UIColor clearColor];
    genderBackgroundView.center = self.view.center;
    [self.view addSubview:genderBackgroundView];
    
    buttonHeight = 110;
    self.offCampusButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(0, 0, buttonHeight, buttonHeight)];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateNormal];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateHighlighted];
    _offCampusButton.tag = OFF_BUTTON;
    _offCampusButton.top = 30;
    _offCampusButton.onImage = @"offcampus_s";
    _offCampusButton.offImage = @"offcampus_d";
    _offCampusButton.right = floor(genderBackgroundView.width/2);
    _offCampusButton.centerY = floorf(genderBackgroundView.height/2);
    [_offCampusButton toggle:NO]; // OFF
    [_offCampusButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_offCampusButton];
    
    
    self.onCampusButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_offCampusButton.right +2, _offCampusButton.top, _offCampusButton.width, _offCampusButton.height)];
    [_onCampusButton setTitle:@"On campus" forState:UIControlStateNormal];
    [_onCampusButton setTitle:@"On campus" forState:UIControlStateHighlighted];
    _onCampusButton.tag = ON_BUTTON;
    _onCampusButton.top = _offCampusButton.top;
    _onCampusButton.left = _offCampusButton.right+1;
    _onCampusButton.onImage = @"oncampus_s";
    _onCampusButton.offImage = @"oncampus_d";
    [_onCampusButton toggle:NO]; // OFF
    [_onCampusButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_onCampusButton];
    
    [self setLocation];
    
}

- (void)genderTogglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == OFF_BUTTON)
    {
        [_onCampusButton toggle:NO];
        _onCampusButton.titleLabel.textColor = [UIColor darkGrayColor];
        _offCampusButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.campus = @1;
    }
    else if(senderButton.tag == ON_BUTTON)
    {
        [_offCampusButton toggle:NO];
        _offCampusButton.titleLabel.textColor = [UIColor darkGrayColor];
        _onCampusButton.titleLabel.textColor = [UIColor whiteColor];
        _currentUser.campus = @0;
    }
    
    
}

- (void)setLocation
{
    if([_currentUser.campus intValue] == 1)
    {
        [_onCampusButton toggle:NO];
        [_offCampusButton toggle:YES];
        _onCampusButton.titleLabel.textColor = [UIColor darkGrayColor];
        _offCampusButton.titleLabel.textColor = [UIColor whiteColor];
        
    }else if([_currentUser.gender intValue] == 0)
    {
        [_offCampusButton toggle:NO];
        [_onCampusButton toggle:YES];
        _offCampusButton.titleLabel.textColor = [UIColor darkGrayColor];
        _onCampusButton.titleLabel.textColor = [UIColor whiteColor];
        
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
