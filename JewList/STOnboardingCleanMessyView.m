//
//  STOnboardingCleanMessyView.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "STOnboardingCleanMessyView.h"

#define CLEAN_BUTTON 0
#define MESSY_BUTTON 1

@implementation STOnboardingCleanMessyView

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
    _textView.placeholder = @"Do you clean after yourself?";
    _textView.placeholderColor = DEFAULT_LIGHT_GRAY_COLOR;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.width/2);
    _textView.clipsToBounds = YES;
    [self addSubview:_textView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.user.cleaningText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Are you more a clean or messy person?";
    
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
    self.user.cleaningText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 110;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.messyButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_messyButton setTitle:@"Messy" forState:UIControlStateNormal];
    [_messyButton setTitle:@"Messy" forState:UIControlStateHighlighted];
    [_messyButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _messyButton.tag = MESSY_BUTTON;
    _messyButton.right = floor(buttonsBackgroundView.width/2);
    _messyButton.centerY = floorf(buttonsBackgroundView.height/2);
    _messyButton.onImage = @"messy_s";
    _messyButton.offImage = @"messy_d";
    [_messyButton toggle:[self.user.cleaning intValue] == 1];
    [_messyButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_messyButton];
    
    self.cleanButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_messyButton.right +2, _messyButton.top, _messyButton.width, _messyButton.height)];
    _cleanButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
    [_cleanButton setTitle:@"Clean" forState:UIControlStateHighlighted];
    [_cleanButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _cleanButton.tag = CLEAN_BUTTON;
    _cleanButton.onImage = @"clean_s";
    _cleanButton.offImage = @"clean_d";
    _cleanButton.top = _messyButton.top;
    _cleanButton.left = _messyButton.right+1;
    [_cleanButton toggle:[self.user.cleaning intValue] == 0];
    [_cleanButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_cleanButton];
    
    return buttonsBackgroundView;
    
}

- (void)togglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == MESSY_BUTTON && [senderButton isOn])
    {
        [_cleanButton toggle:NO];
        _cleanButton.titleLabel.textColor = [UIColor darkGrayColor];
        _messyButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.cleaning = @1;
        
    }
    else if(senderButton.tag == CLEAN_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.cleaning = @0;
        
    }
    
    
}

@end
