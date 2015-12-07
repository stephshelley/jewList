//
//  STOnboardingWorkPlayView.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "STOnboardingWorkPlayView.h"
#import "JLColors.h"

#define WORK_BUTTON 0
#define PLAY_BUTTON 1

@implementation STOnboardingWorkPlayView

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
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _headerTopView.width - 50, _headerTopView.height)];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:15];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.adjustsFontSizeToFitWidth = YES;
    _headerLabel.numberOfLines = 2;
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.centerX = floorf(_headerTopView.width/2);
    [_headerTopView addSubview:_headerLabel];
    
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, _headerTopView.bottom + 5, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.placeholder = @"How do you prefer spending your friday nights?";
    _textView.placeholderColor = DEFAULT_LIGHT_GRAY_COLOR;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.width/2);
    _textView.clipsToBounds = YES;
    [self addSubview:_textView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.user.personalityText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Are you more a party or work kind of person?";
    
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
    self.user.personalityText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 110;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:buttonsBackgroundView];
    
    self.playButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_playButton setTitle:@"Party" forState:UIControlStateNormal];
    [_playButton setTitle:@"Party" forState:UIControlStateHighlighted];
    [_playButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _playButton.tag = PLAY_BUTTON;
    _playButton.right = floor(buttonsBackgroundView.width/2);
    _playButton.centerY = floorf(buttonsBackgroundView.height/2);
    _playButton.onImage = @"party_s";
    _playButton.offImage = @"party_d";
    [_playButton toggle:[self.user.personality intValue] == 1];
    [_playButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_playButton];
    
    self.workButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(0, 0, buttonHeight, buttonHeight)];
    _workButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_workButton setTitle:@"Work" forState:UIControlStateNormal];
    [_workButton setTitle:@"Work" forState:UIControlStateHighlighted];
    [_workButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _workButton.tag = WORK_BUTTON;
    _workButton.onImage = @"study_s";
    _workButton.offImage = @"study_d";
    _workButton.top = _playButton.top;
    _workButton.left = _playButton.right+1;
    [_workButton toggle:[self.user.personality intValue] == 0];
    [_workButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_workButton];
    
    
    return buttonsBackgroundView;
    
}

- (void)togglePressed:(id)sender
{
    SHToggleButton *senderButton = (SHToggleButton*)sender;
    [senderButton toggle];
    
    if(senderButton.tag == PLAY_BUTTON && [senderButton isOn])
    {
        [_workButton toggle:NO];
        _workButton.titleLabel.textColor = [UIColor darkGrayColor];
        _playButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.personality = @1;
        
    }
    else if(senderButton.tag == WORK_BUTTON && [senderButton isOn])
    {
        [_playButton toggle:NO];
        _playButton.titleLabel.textColor = [UIColor darkGrayColor];
        _workButton.titleLabel.textColor = [UIColor whiteColor];
        self.user.personality = @0;
        
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
