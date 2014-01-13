//
//  SHShabbatViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHShabbatViewController.h"

#define UBER_BUTTON 0
#define MILD_BUTTON 1
#define MEH_BUTTON 2

@interface SHShabbatViewController ()

@end

@implementation SHShabbatViewController

- (void)loadView
{
    [super loadView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.currentUser.religiousText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Rate your Jewness?";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.religiousText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 60;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,80)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.mildJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight + 20, buttonHeight)];
    [_mildJew setColorOff:[UIColor grayColor]];
    [_mildJew setColorOn:DEFAULT_BLUE_COLOR];
    [_mildJew setTitle:@"Mild" forState:UIControlStateNormal];
    [_mildJew setTitle:@"Mild" forState:UIControlStateHighlighted];
    [_mildJew setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _mildJew.tag = MILD_BUTTON;
    _mildJew.centerX = floor(buttonsBackgroundView.width/2);
    _mildJew.top = 0;
    _mildJew.onImage = @"mild_s";
    _mildJew.offImage = @"mild_d";
    _mildJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _mildJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_mildJew toggle:[self.currentUser.religious intValue] == 1];
    [_mildJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_mildJew];
    
    /*
    UIImageView *mildImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    mildImage.image = [UIImage imageNamed:@"girlfinal"];
    mildImage.centerX = floorf(_mildJew.width/2);
    mildImage.centerY = floorf(_mildJew.height/2);
    mildImage.userInteractionEnabled = NO;
    [_mildJew addSubview:mildImage];
     */
    
    self.uberJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight + 20, buttonHeight)];
    [_uberJew setColorOff:[UIColor grayColor]];
    [_uberJew setColorOn:DEFAULT_BLUE_COLOR];
    [_uberJew setTitle:@"Uber" forState:UIControlStateNormal];
    [_uberJew setTitle:@"Uber" forState:UIControlStateHighlighted];
    [_uberJew setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _uberJew.tag = UBER_BUTTON;
    _uberJew.right = _mildJew.left - 20;
    _uberJew.top = 0;
    _uberJew.onImage = @"uber_s";
    _uberJew.offImage = @"uber_d";
    _uberJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _uberJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_uberJew toggle:[self.currentUser.religious intValue] == 0];
    [_uberJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_uberJew];
    
    /*
    UIImageView *uberImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    uberImage.image = [UIImage imageNamed:@"girlfinal"];
    uberImage.centerX = floorf(_uberJew.width/2);
    uberImage.centerY = floorf(_uberJew.height/2);
    uberImage.userInteractionEnabled = NO;
    [_uberJew addSubview:uberImage];
     */
    
    self.mehJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight + 20, buttonHeight)];
    [_mehJew setColorOff:[UIColor grayColor]];
    [_mehJew setColorOn:DEFAULT_BLUE_COLOR];
    _mehJew.backgroundColor = DEFAULT_BLUE_COLOR;
    [_mehJew setTitle:@"Meh" forState:UIControlStateNormal];
    [_mehJew setTitle:@"Meh" forState:UIControlStateHighlighted];
    [_mehJew setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _mehJew.tag = MEH_BUTTON;
    _mehJew.onImage = @"meh_s";
    _mehJew.offImage = @"meh_d";
    _mehJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _mehJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    _mehJew.top = _uberJew.top;
    _mehJew.left = _mildJew.right + 20;
    [_mehJew toggle:[self.currentUser.religious intValue] == 2];
    [_mehJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_mehJew];
    
    UIImageView *mehImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    mehImage.image = [UIImage imageNamed:@"boyfinal"];
    mehImage.centerX = floorf(_mehJew.width/2);
    mehImage.centerY = floorf(_mehJew.height/2);
    mehImage.userInteractionEnabled = NO;
    [_mehJew addSubview:mehImage];
    
    return buttonsBackgroundView;
    
}

- (void)togglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == UBER_BUTTON && [senderButton isOn])
    {
        [_mehJew toggle:NO];
        [_mildJew toggle:NO];
        _mehJew.titleLabel.textColor = [UIColor darkGrayColor];
        _mildJew.titleLabel.textColor = [UIColor darkGrayColor];
        _uberJew.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.religious = @0;
        
    }
    else if(senderButton.tag == MILD_BUTTON && [senderButton isOn])
    {
        [_mehJew toggle:NO];
        [_uberJew toggle:NO];
        _mehJew.titleLabel.textColor = [UIColor darkGrayColor];
        _uberJew.titleLabel.textColor = [UIColor darkGrayColor];
        _mildJew.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.religious = @1;
        
    }else if(senderButton.tag == MEH_BUTTON && [senderButton isOn])
    {
        [_mildJew toggle:NO];
        [_uberJew toggle:NO];
        _mildJew.titleLabel.textColor = [UIColor darkGrayColor];
        _uberJew.titleLabel.textColor = [UIColor darkGrayColor];
        _mehJew.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.religious = @2;
        
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
