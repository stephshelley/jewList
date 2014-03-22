//
//  SHOnboarding1View.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHOnboarding1View.h"
#import "User.h"
#import "SHApi.h"
#import "JLColors.h"
#import "SHToggleButton.h"
#import "UIView+FindAndResignFirstResponder.h"

#define TAG_MALE_BUTTON 0
#define TAG_FEMALE_BUTTON 1

@implementation SHOnboarding1View


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

- (void)loadUI
{
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIView *userTopView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.width, 85)];
    userTopView.backgroundColor = [UIColor clearColor];
    [self addSubview:userTopView];
    
    CGFloat userPicHeight = 70;
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, userPicHeight, userPicHeight)];
    _userImageView.centerY = floorf(userTopView.height/2);
    _userImageView.backgroundColor = [UIColor clearColor];
    [_userImageView setUserImagePathToNetworkImage:[_user fbImageUrlForSize:_userImageView.size] forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    [userTopView addSubview:_userImageView];
    
    UIFont *hiLabelFont = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:19.0f];
    self.hiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.right + 10, _userImageView.top - 2, self.width - 20 - (_userImageView.right + 10), hiLabelFont.lineHeight)];
    _hiLabel.textAlignment = NSTextAlignmentLeft;
    _hiLabel.font = hiLabelFont;
    _hiLabel.textColor = DEFAULT_BLUE_COLOR;
    _hiLabel.backgroundColor = [UIColor clearColor];
    _hiLabel.text = [NSString stringWithFormat:@"Hi %@!",_user.firstName];
    [userTopView addSubview:_hiLabel];
    
    self.letsGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hiLabel.left, _hiLabel.bottom, _hiLabel.width, 8 + _userImageView.bottom - _hiLabel.bottom)];
    _letsGoLabel.textAlignment = NSTextAlignmentLeft;
    _letsGoLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14.0f];
    _letsGoLabel.textColor = [UIColor blackColor];
    _letsGoLabel.backgroundColor = [UIColor clearColor];
    _letsGoLabel.numberOfLines = 2;
    _letsGoLabel.text = @"First make sure you are OK with the info we have for you";
    [userTopView addSubview:_letsGoLabel];
    
    UIView *nameBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, userTopView.bottom + 5, self.width, 70)];
    nameBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:nameBackground];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, nameBackground.width, 1)];
    sepView.bottom = nameBackground.top;
    sepView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:sepView];
    
    self.nameTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(10, 0, nameBackground.width - 20, 32)];
    _nameTextField.placeholder = @"Your Name";
    _nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:20];
    _nameTextField.centerY = floorf(nameBackground.height/2);
    _nameTextField.textColor = DEFAULT_BLUE_COLOR;
    _nameTextField.backgroundColor = [UIColor clearColor];
    [nameBackground addSubview:_nameTextField];
    
    UIView *sepView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, nameBackground.width, 1)];
    sepView2.bottom = nameBackground.height;
    sepView2.backgroundColor = UIColorFromRGB(0xcccccc);
    [nameBackground addSubview:sepView2];

    UIView *emailBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, nameBackground.bottom, self.width, nameBackground.height)];
    emailBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:emailBackground];
    
    self.emailTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(10, 0, emailBackground.size.width - 20, _nameTextField.height)];
    _emailTextField.placeholder = @"Your email";
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.delegate = self;
    _emailTextField.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_nameTextField.font.pointSize];
    _emailTextField.textAlignment = NSTextAlignmentLeft;
    _emailTextField.textColor = DEFAULT_BLUE_COLOR;
    _emailTextField.centerY = floorf(emailBackground.height/2);
    _emailTextField.backgroundColor = [UIColor clearColor];
    _emailTextField.text = _user.email;
    [emailBackground addSubview:_emailTextField];
    
    
    UIView *sepView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, emailBackground.width, 1)];
    sepView4.bottom = emailBackground.height;
    sepView4.backgroundColor = UIColorFromRGB(0xcccccc);
    [emailBackground addSubview:sepView4];

    
    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    _nextStepButton.bottom = self.height;
    [_nextStepButton setTitle:@"That's me!" forState:UIControlStateNormal];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nextStepButton];
    
    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, emailBackground.bottom, self.width, _nextStepButton.top - emailBackground.bottom)];
    genderBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:genderBackgroundView];
    
    buttonHeight = 140;
    self.femaleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2, genderBackgroundView.height/2 - buttonHeight/2, buttonHeight, buttonHeight)];
    //[_femaleButton setTitle:@"Female" forState:UIControlStateNormal];
    //[_femaleButton setTitle:@"Female" forState:UIControlStateHighlighted];
    _femaleButton.tag = TAG_FEMALE_BUTTON;
    _femaleButton.colorOn = [UIColor clearColor];
    _femaleButton.colorOff = [UIColor clearColor];
    _femaleButton.top = 30;
    _femaleButton.onImage = @"female_s";
    _femaleButton.offImage = @"female_d";
    _femaleButton.right = floor(genderBackgroundView.width/2);
    _femaleButton.centerY = floorf(genderBackgroundView.height/2);
    [_femaleButton toggle:NO]; // OFF
    [_femaleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_femaleButton];
    
     
    self.maleButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_femaleButton.right +2, _femaleButton.top, _femaleButton.width, _femaleButton.height)];
    //[_maleButton setTitle:@"Male" forState:UIControlStateNormal];
    //[_maleButton setTitle:@"Male" forState:UIControlStateHighlighted];
    _maleButton.tag = TAG_MALE_BUTTON;
    _maleButton.colorOn = [UIColor clearColor];
    _maleButton.colorOff = [UIColor clearColor];
    _maleButton.top = _femaleButton.top;
    _maleButton.left = _femaleButton.right+1;
    _maleButton.onImage = @"male_s";
    _maleButton.offImage = @"male_d";
    [_maleButton toggle:NO]; // OFF
    [_maleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_maleButton];

    
    _nameTextField.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
    _homeTownTextField.text = SAFE_VAL(_user.fbHometownName);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    
    [self setGender];
}

- (void)setGender
{
    if([_user.gender intValue] == 1)
    {
        [_maleButton toggle:NO];
        [_femaleButton toggle:YES];
        _maleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _femaleButton.titleLabel.textColor = [UIColor whiteColor];
        _user.gender = @1;//female

    }else if([_user.gender intValue] == 0)
    {
        [_femaleButton toggle:NO];
        [_maleButton toggle:YES];
        _femaleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _maleButton.titleLabel.textColor = [UIColor whiteColor];
        _user.gender = @0; // male

    }
}

- (void)dismissKeyboard {
    [self findAndResignFirstResponder];
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
        _user.gender = @1;
    }
    else if(senderButton.tag == TAG_MALE_BUTTON && [senderButton isOn])
    {
        [_femaleButton toggle:NO];
        _femaleButton.titleLabel.textColor = [UIColor darkGrayColor];
        _maleButton.titleLabel.textColor = [UIColor whiteColor];
        _user.gender = @0;
    }
    
    [[SHApi sharedInstance] cacheCurrentUserDetails];
}


#pragma mark == Textfield Delegate ==

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = YES;
    if(textField)
    {
        if([textField isEqual:_nameTextField])
        {
            [_emailTextField becomeFirstResponder];
            
        }
        else if([textField isEqual:_homeTownTextField])
        {
            [_emailTextField becomeFirstResponder];

        }else if([textField isEqual:_emailTextField])
        {
            [_emailTextField resignFirstResponder];
            
        }
    }
    
    return shouldReturn;
    
}

@end
