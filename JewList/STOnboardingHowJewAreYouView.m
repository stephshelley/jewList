//
//  STOnboardingHowJewAreYouView.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "STOnboardingHowJewAreYouView.h"

#define UBER_BUTTON 0
#define MILD_BUTTON 1
#define MEH_BUTTON 2

@implementation STOnboardingHowJewAreYouView

- (id)initWithFrame:(CGRect)frame andUser:(User*)user
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.user = user;
        [self loadUI];
        
    }
    
    return self;
    
}

- (void)popScreen
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToPreviousStep:)])
        [_delegate goToPreviousStep:self];
    
}

- (void)loadUI
{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
    _headerTopView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self addSubview:_headerTopView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 20, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(_headerTopView.height/2) + 10;
    leftButtonView.left = -2;
    [_headerTopView addSubview:leftButtonView];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _headerTopView.width - 20, _headerTopView.height)];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.adjustsFontSizeToFitWidth = YES;
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.centerX = floorf(_headerTopView.width/2);
    [_headerTopView addSubview:_headerLabel];
    
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, _headerTopView.bottom + 5, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.placeholder = @"Are you strict or just 'culturally' jewish?";
    _textView.placeholderColor = DEFAULT_LIGHT_GRAY_COLOR;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.width/2);
    _textView.clipsToBounds = YES;
    [self addSubview:_textView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.user.religiousText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Rate your Jewness";
    
    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    _nextStepButton.bottom = self.height;
    [_nextStepButton setTitle:@"Next" forState:UIControlStateNormal];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nextStepButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.user.religiousText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 80;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.mildJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_mildJew setTitle:@"Sometimes" forState:UIControlStateNormal];
    [_mildJew setTitle:@"Sometimes" forState:UIControlStateHighlighted];
    [_mildJew setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _mildJew.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _mildJew.buttonImage.centerX = floorf(_mildJew.width/2);
    _mildJew.tag = MILD_BUTTON;
    _mildJew.centerX = floor(buttonsBackgroundView.width/2);
    _mildJew.centerY = floorf(buttonsBackgroundView.height/2);
    _mildJew.onImage = @"mild_s";
    _mildJew.offImage = @"mild_d";
    _mildJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _mildJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_mildJew toggle:[self.user.religious intValue] == 1];
    [_mildJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_mildJew];
    
    
    self.uberJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight, buttonHeight)];
    [_uberJew setTitle:@"Super" forState:UIControlStateNormal];
    [_uberJew setTitle:@"Super" forState:UIControlStateHighlighted];
    [_uberJew setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _uberJew.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _uberJew.buttonImage.centerX = floorf(_uberJew.width/2);
    _uberJew.tag = UBER_BUTTON;
    _uberJew.right = _mildJew.left - 20;
    _uberJew.top = _mildJew.top;
    _uberJew.onImage = @"uber_s";
    _uberJew.offImage = @"uber_d";
    _uberJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _uberJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_uberJew toggle:[self.user.religious intValue] == 0];
    [_uberJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_uberJew];
    
    self.mehJew = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight, buttonHeight)];
    _mehJew.backgroundColor = DEFAULT_BLUE_COLOR;
    [_mehJew setTitle:@"Seldom" forState:UIControlStateNormal];
    [_mehJew setTitle:@"Seldom" forState:UIControlStateHighlighted];
    [_mehJew setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _mehJew.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _mehJew.buttonImage.centerX = floorf(_mehJew.width/2);
    _mehJew.tag = MEH_BUTTON;
    _mehJew.onImage = @"meh_s";
    _mehJew.offImage = @"meh_d";
    _mehJew.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _mehJew.titleLabel.adjustsFontSizeToFitWidth = YES;
    _mehJew.top = _mildJew.top;
    _mehJew.left = _mildJew.right + 20;
    [_mehJew toggle:[self.user.religious intValue] == 2];
    [_mehJew addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_mehJew];
    
    
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
        self.user.religious = @0;
        
    }
    else if(senderButton.tag == MILD_BUTTON && [senderButton isOn])
    {
        [_mehJew toggle:NO];
        [_uberJew toggle:NO];
        _mehJew.titleLabel.textColor = [UIColor darkGrayColor];
        _uberJew.titleLabel.textColor = [UIColor darkGrayColor];
        _mildJew.titleLabel.textColor = [UIColor whiteColor];
        self.user.religious = @1;
        
    }else if(senderButton.tag == MEH_BUTTON && [senderButton isOn])
    {
        [_mildJew toggle:NO];
        [_uberJew toggle:NO];
        _mildJew.titleLabel.textColor = [UIColor darkGrayColor];
        _uberJew.titleLabel.textColor = [UIColor darkGrayColor];
        _mehJew.titleLabel.textColor = [UIColor whiteColor];
        self.user.religious = @2;
        
    }
    
}

@end
