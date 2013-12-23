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

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat buttonHeight = 120;

    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,120)];
    genderBackgroundView.backgroundColor = [UIColor JLGrey];
    genderBackgroundView.center = self.view.center;
    [self.view addSubview:genderBackgroundView];
    
    self.femaleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_femaleButton setColorOff:[UIColor grayColor]];
    [_femaleButton setColorOn:DEFAULT_BLUE_COLOR];
    [_femaleButton setTitle:@"Female" forState:UIControlStateNormal];
    [_femaleButton setTitle:@"Female" forState:UIControlStateHighlighted];
    [_femaleButton setTitleEdgeInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    _femaleButton.tag = TAG_FEMALE_BUTTON;
    _femaleButton.top = 30;
    _femaleButton.right = floor(genderBackgroundView.width/2);
    _femaleButton.centerY = floorf(genderBackgroundView.height/2);
    [_femaleButton toggle:[_currentUser.gender intValue] == 1]; // OFF
    [_femaleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_femaleButton];
    
    UIImageView *femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    femaleImage.image = [UIImage imageNamed:@"girlfinal"];
    femaleImage.centerX = floorf(_femaleButton.width/2);
    femaleImage.centerY = floorf(_femaleButton.height/2) - 10;
    femaleImage.userInteractionEnabled = NO;
    [_femaleButton addSubview:femaleImage];
    
    self.maleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_femaleButton.right +2, _femaleButton.top, _femaleButton.width, _femaleButton.height)];
    [_maleButton setColorOff:[UIColor grayColor]];
    [_maleButton setColorOn:DEFAULT_BLUE_COLOR];
    _maleButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_maleButton setTitle:@"Male" forState:UIControlStateNormal];
    [_maleButton setTitle:@"Male" forState:UIControlStateHighlighted];
    [_maleButton setTitleEdgeInsets:UIEdgeInsetsMake(100, 0, 0, 0)];
    _maleButton.tag = TAG_MALE_BUTTON;
    _maleButton.top = _femaleButton.top;
    _maleButton.left = _femaleButton.right+1;
    [_maleButton toggle:[_currentUser.gender intValue] == 0]; // OFF
    [_maleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_maleButton];
    
    
    UIImageView *boyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    boyImage.image = [UIImage imageNamed:@"boyfinal"];
    boyImage.centerX = floorf(_maleButton.width/2);
    boyImage.centerY = floorf(_maleButton.height/2) - 10;
    boyImage.userInteractionEnabled = NO;
    [_maleButton addSubview:boyImage];
    
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
