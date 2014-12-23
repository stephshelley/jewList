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
#define CLEAN_FREAK_BUTTON 2

@implementation STOnboardingCleanMessyView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame andUser:(User*)user
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.user = user;
        [self loadUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillShowKeyboardNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillHideKeyboardNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        
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
    CGFloat buttonHeight = 88;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.cleanButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_cleanButton setTitle:@"Organized" forState:UIControlStateNormal];
    [_cleanButton setTitle:@"Organized" forState:UIControlStateHighlighted];
    [_cleanButton setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _cleanButton.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _cleanButton.buttonImage.centerX = floorf(_cleanButton.width/2);
    _cleanButton.tag = CLEAN_BUTTON;
    _cleanButton.centerX = floor(buttonsBackgroundView.width/2);
    _cleanButton.centerY = floorf(buttonsBackgroundView.height/2);
    _cleanButton.onImage = @"organized_s";
    _cleanButton.offImage = @"organized_d";
    _cleanButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _cleanButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_cleanButton toggle:[self.user.cleaning intValue] == 1];
    [_cleanButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_cleanButton];
    
    
    self.cleanFreakButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight, buttonHeight)];
    [_cleanFreakButton setTitle:@"Clean Freak" forState:UIControlStateNormal];
    [_cleanFreakButton setTitle:@"Clean Freak" forState:UIControlStateHighlighted];
    [_cleanFreakButton setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _cleanFreakButton.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _cleanFreakButton.buttonImage.centerX = floorf(_cleanFreakButton.width/2);
    _cleanFreakButton.tag = CLEAN_FREAK_BUTTON;
    _cleanFreakButton.right = _cleanButton.left - 20;
    _cleanFreakButton.top = _cleanButton.top;
    _cleanFreakButton.onImage = @"cleanfreak_s";
    _cleanFreakButton.offImage = @"cleanfreak_d";
    _cleanFreakButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _cleanFreakButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_cleanFreakButton toggle:[self.user.cleaning intValue] == 2];
    [_cleanFreakButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_cleanFreakButton];
    
    self.messyButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(0,0, buttonHeight, buttonHeight)];
    _messyButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_messyButton setTitle:@"Messy" forState:UIControlStateNormal];
    [_messyButton setTitle:@"Messy" forState:UIControlStateHighlighted];
    [_messyButton setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
    _messyButton.buttonImage.frame = CGRectMake(0, 0, 70, 70);
    _messyButton.buttonImage.centerX = floorf(_messyButton.width/2);
    _messyButton.tag = MESSY_BUTTON;
    _messyButton.onImage = @"messy_s";
    _messyButton.offImage = @"messy_d";
    _messyButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _messyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _messyButton.top = _cleanButton.top;
    _messyButton.left = _cleanButton.right + 20;
    [_messyButton toggle:[self.user.cleaning intValue] == 0];
    [_messyButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_messyButton];
    
    return buttonsBackgroundView;
    
}

- (void)togglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == MESSY_BUTTON && [senderButton isOn])
    {
        [_cleanButton toggle:NO];
        [_cleanFreakButton toggle:NO];
        _cleanFreakButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor darkGrayColor];
        _messyButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.cleaning = @0;
        
    }
    else if(senderButton.tag == CLEAN_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        [_cleanFreakButton toggle:NO];
        _cleanFreakButton.titleLabel.textColor = [UIColor darkGrayColor];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.cleaning = @1;
        
    }
    else if(senderButton.tag == CLEAN_FREAK_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        [_cleanButton toggle:NO];
        _cleanFreakButton.titleLabel.textColor = [UIColor whiteColor];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor darkGrayColor];
        self.user.cleaning = @2;
        
    }
    
    
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(curve << 16)
                     animations:^{
                         
                         _nextStepButton.bottom = self.height - keyboardHeight;
                         
                     }
                     completion:nil];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(curve << 16)
                     animations:^{
                         _nextStepButton.bottom = self.height;
                         
                         
                     }
                     completion:nil];
    
}


@end
