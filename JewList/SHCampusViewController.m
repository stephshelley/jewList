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

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat buttonHeight = 120;
    
    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,120)];
    genderBackgroundView.backgroundColor = [UIColor JLGrey];
    genderBackgroundView.center = self.view.center;
    [self.view addSubview:genderBackgroundView];
    
    self.offCampusButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_offCampusButton setColorOff:[UIColor grayColor]];
    [_offCampusButton setColorOn:DEFAULT_BLUE_COLOR];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateNormal];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateHighlighted];
    [_offCampusButton setTitleEdgeInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    _offCampusButton.tag = OFF_BUTTON;
    _offCampusButton.top = 30;
    _offCampusButton.right = floor(genderBackgroundView.width/2);
    _offCampusButton.centerY = floorf(genderBackgroundView.height/2);
    [_offCampusButton toggle:[_currentUser.campus intValue] == 1];
    [_offCampusButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_offCampusButton];
    
    UIImageView *offCampusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    offCampusImage.image = [UIImage imageNamed:@"girlfinal"];
    offCampusImage.centerX = floorf(_offCampusButton.width/2);
    offCampusImage.centerY = floorf(_offCampusButton.height/2) - 10;
    offCampusImage.userInteractionEnabled = NO;
    [_offCampusButton addSubview:offCampusImage];
    
    self.onCampusButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_offCampusButton.right +2, _offCampusButton.top, _offCampusButton.width, _offCampusButton.height)];
    [_onCampusButton setColorOff:[UIColor grayColor]];
    [_onCampusButton setColorOn:DEFAULT_BLUE_COLOR];
    _onCampusButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_onCampusButton setTitle:@"On campus" forState:UIControlStateNormal];
    [_onCampusButton setTitle:@"On campus" forState:UIControlStateHighlighted];
    [_onCampusButton setTitleEdgeInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    _onCampusButton.tag = ON_BUTTON;
    _onCampusButton.top = _offCampusButton.top;
    _onCampusButton.left = _offCampusButton.right+1;
    [_onCampusButton toggle:[_currentUser.campus intValue] == 0];
    [_onCampusButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_onCampusButton];
    
    UIImageView *onCampusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    onCampusImage.image = [UIImage imageNamed:@"boyfinal"];
    onCampusImage.centerX = floorf(_onCampusButton.width/2);
    onCampusImage.centerY = floorf(_onCampusButton.height/2) - 10;
    onCampusImage.userInteractionEnabled = NO;
    [_onCampusButton addSubview:onCampusImage];
    
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
