//
//  STOnboardingKosherView.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "STOnboardingKosherView.h"

#define KOSHER_BUTTON 0
#define NON_KOSHER_BUTTON 1

@implementation STOnboardingKosherView

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
    _textView.textColor = [UIColor blackColor];
    _textView.placeholder = @"Where do you draw the line?";
    _textView.placeholderColor = DEFAULT_LIGHT_GRAY_COLOR;
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.width/2);
    _textView.clipsToBounds = YES;
    [self addSubview:_textView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.user.dietText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Do you keep kosher?";
    
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
    self.user.dietText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 110;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 30, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.nonKosherButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2 - 4,0, buttonHeight + 20, buttonHeight)];
    [_nonKosherButton setTitle:@"Non Kosher" forState:UIControlStateNormal];
    [_nonKosherButton setTitle:@"Non Kosher" forState:UIControlStateHighlighted];
    [_nonKosherButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _nonKosherButton.tag = NON_KOSHER_BUTTON;
    _nonKosherButton.right = floor(buttonsBackgroundView.width/2) - 2;
    _nonKosherButton.centerY = floorf(buttonsBackgroundView.height/2);
    _nonKosherButton.onImage = @"nonkosher_s";
    _nonKosherButton.offImage = @"nonkosher_d";
    _nonKosherButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _nonKosherButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_nonKosherButton toggle:[self.user.diet intValue] == 1];
    [_nonKosherButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_nonKosherButton];
    
    self.kosherButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_nonKosherButton.right +4, _nonKosherButton.top, _nonKosherButton.width, _nonKosherButton.height)];
    _kosherButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_kosherButton setTitle:@"Kosher" forState:UIControlStateNormal];
    [_kosherButton setTitle:@"Kosher" forState:UIControlStateHighlighted];
    [_kosherButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _kosherButton.tag = KOSHER_BUTTON;
    _kosherButton.onImage = @"kosher_s";
    _kosherButton.offImage = @"kosher_d";
    _kosherButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _kosherButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _kosherButton.top = _nonKosherButton.top;
    _kosherButton.left = _nonKosherButton.right+3;
    [_kosherButton toggle:[self.user.diet intValue] == 0];
    [_kosherButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_kosherButton];
    
    return buttonsBackgroundView;
    
}

- (void)togglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == NON_KOSHER_BUTTON && [senderButton isOn])
    {
        [_kosherButton toggle:NO];
        _kosherButton.titleLabel.textColor = [UIColor darkGrayColor];
        _nonKosherButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.diet = @1;
        
    }
    else if(senderButton.tag == KOSHER_BUTTON && [senderButton isOn])
    {
        [_nonKosherButton toggle:NO];
        _nonKosherButton.titleLabel.textColor = [UIColor darkGrayColor];
        _kosherButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.diet = @0;
        
    }
    
    
}


@end
