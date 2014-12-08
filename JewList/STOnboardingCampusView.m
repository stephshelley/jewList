//
//  STOnboardingCampusView.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "STOnboardingCampusView.h"

#define ON_BUTTON 0
#define OFF_BUTTON 1

@implementation STOnboardingCampusView

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
    _headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:15];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.numberOfLines = 2;
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
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.width/2);
    _textView.clipsToBounds = YES;
    [self addSubview:_textView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.height = 100;
    self.textView.delegate = self;
    self.textView.userInteractionEnabled = NO;
    self.headerLabel.text = @"Do you live on/off campus?";
    
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


- (UIView *)toggleView
{
    CGFloat buttonHeight = 110;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.offCampusButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateNormal];
    [_offCampusButton setTitle:@"Off campus" forState:UIControlStateHighlighted];
    _offCampusButton.tag = OFF_BUTTON;
    _offCampusButton.top = 30;
    _offCampusButton.onImage = @"offcampus_s";
    _offCampusButton.offImage = @"offcampus_d";
    _offCampusButton.right = floor(buttonsBackgroundView.width/2);
    _offCampusButton.centerY = floorf(buttonsBackgroundView.height/2);
    [_offCampusButton toggle:NO]; // OFF
    [_offCampusButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_offCampusButton];
    
    
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
    [buttonsBackgroundView addSubview:_onCampusButton];
    
    return buttonsBackgroundView;
    
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
        self.user.campus = @1;
    }
    else if(senderButton.tag == ON_BUTTON)
    {
        [_offCampusButton toggle:NO];
        _offCampusButton.titleLabel.textColor = [UIColor darkGrayColor];
        _onCampusButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.campus = @0;
    }
    
}

@end
