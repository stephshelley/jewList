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
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
    progressBar.backgroundColor = [UIColor JLGreen];
    UIView *progressMade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, progressBar.frame.size.width/3, progressBar.frame.size.height)];
    progressMade.backgroundColor = [UIColor JLDarkGreen];
    [progressBar addSubview:progressMade];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:progressBar.frame];
    progressLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.text = @"Step 1/3";
    [progressBar addSubview:progressLabel];
    [self addSubview:progressBar];
    
    UIView *userTopView = [[UIView alloc] initWithFrame:CGRectMake(0, progressBar.frame.origin.y + progressBar.frame.size.height, self.width, 73)];
    userTopView.backgroundColor = [UIColor JLGrey];
    [self addSubview:userTopView];
    
    CGFloat userPicHeight = 50;
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(10, userTopView.frame.size.height/2 - userPicHeight/2, userPicHeight, userPicHeight)];
    _userImageView.backgroundColor = [UIColor whiteColor];
    [_userImageView setPathToNetworkImage:_user.fbImageUrl forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    [userTopView addSubview:_userImageView];
    
    UIFont *hiLabelFont = [UIFont fontWithName:DEFAULT_FONT size:17.0f];
    self.hiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.right + 10, _userImageView.top, self.width - 10 - (_userImageView.right + 10), hiLabelFont.lineHeight)];
    _hiLabel.textAlignment = NSTextAlignmentLeft;
    _hiLabel.font = hiLabelFont;
    _hiLabel.textColor = [UIColor whiteColor];
    _hiLabel.backgroundColor = [UIColor clearColor];
    _hiLabel.text = [NSString stringWithFormat:@"Hi %@!",_user.firstName];
    [userTopView addSubview:_hiLabel];
    
    self.letsGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hiLabel.left, _hiLabel.bottom, _hiLabel.width, _userImageView.bottom - _hiLabel.bottom)];
    _letsGoLabel.textAlignment = NSTextAlignmentLeft;
    _letsGoLabel.font = [UIFont fontWithName:DEFAULT_FONT size:10.0f];
    _letsGoLabel.textColor = [UIColor whiteColor];
    _letsGoLabel.backgroundColor = [UIColor clearColor];
    _letsGoLabel.numberOfLines = 2;
    _letsGoLabel.text = @"Let's just make sure you are ok with the info we got on you";
    [userTopView addSubview:_letsGoLabel];
    
    UIView *nameBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, userTopView.bottom, self.width, 40)];
    nameBackground.backgroundColor = [UIColor whiteColor];
    [self addSubview:nameBackground];
    
    self.nameTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(0, 0, nameBackground.width, nameBackground.height)];
    _nameTextField.placeholder = @"Your Name";
    _nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    [nameBackground addSubview:_nameTextField];
    
    UILabel *nameIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0, nameBackground.bottom, self.width, 20)];
    nameIndicator.backgroundColor = [UIColor JLGrey];
    nameIndicator.textColor = [UIColor whiteColor];
    nameIndicator.textAlignment = NSTextAlignmentLeft;
    nameIndicator.font = [UIFont fontWithName:DEFAULT_FONT size:12.0f];
    nameIndicator.text = @"  Your name";
    [self addSubview:nameIndicator];

    UIView *homeBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, nameIndicator.bottom, self.width, nameBackground.height)];
    homeBackground.backgroundColor = [UIColor whiteColor];
    [self addSubview:homeBackground];
    
    self.homeTownTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(0, 0, homeBackground.size.width, homeBackground.size.height)];
    _homeTownTextField.placeholder = @"Home Town";
    _homeTownTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _homeTownTextField.returnKeyType = UIReturnKeyNext;
    _homeTownTextField.delegate = self;
    _homeTownTextField.textAlignment = NSTextAlignmentLeft;
    [homeBackground addSubview:_homeTownTextField];
    
    UILabel *homeIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0, homeBackground.bottom, self.width, 20)];
    homeIndicator.backgroundColor = [UIColor JLGrey];
    homeIndicator.textColor = [UIColor whiteColor];
    homeIndicator.textAlignment = NSTextAlignmentLeft;
    homeIndicator.font = [UIFont fontWithName:DEFAULT_FONT size:12.0f];
    homeIndicator.text = @"  Your hometown";
    [self addSubview:homeIndicator];

    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height-buttonHeight, self.width, buttonHeight)];
    _nextStepButton.backgroundColor = [UIColor JLBlue];
    [_nextStepButton setTitle:@"Yep, move on." forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Yep, move on." forState:UIControlStateHighlighted];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = userTopView.centerX;
    [self addSubview:_nextStepButton];
    
    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, homeIndicator.bottom, self.width, _nextStepButton.top - homeIndicator.bottom)];
    genderBackgroundView.backgroundColor = [UIColor purpleColor];
    [self addSubview:genderBackgroundView];
    
    buttonHeight = 140;
    self.femaleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2 - (buttonHeight*2 +2)/2, genderBackgroundView.height/2 - buttonHeight/2, buttonHeight, buttonHeight)];
    _femaleButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_femaleButton setTitle:@"Female" forState:UIControlStateNormal];
    [_femaleButton setTitle:@"Female" forState:UIControlStateHighlighted];
    _femaleButton.tag = 1;
    _femaleButton.right = floor(genderBackgroundView.width/2);
    [_femaleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_femaleButton];
    
    self.maleButton = [[UIButton alloc] initWithFrame:CGRectMake(_femaleButton.right +2, _femaleButton.top, _femaleButton.width, _femaleButton.height)];
    _maleButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_maleButton setTitle:@"Male" forState:UIControlStateNormal];
    [_maleButton setTitle:@"Male" forState:UIControlStateHighlighted];
    _maleButton.tag = 0;
    [_maleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_maleButton];

    
    _nameTextField.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
    _homeTownTextField.text = SAFE_VAL(_user.fbHometownName);
    
}

- (void)genderTogglePressed:(id)sender
{
    UIButton *senderButton = (UIButton*)sender;
    
    if(senderButton.tag == 1)
    {
        _user.gendre = @"female";
    }else if(senderButton.tag == 0)
    {
        _user.gendre = @"male";
        
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
            [_homeTownTextField becomeFirstResponder];
            
        }
        else if([textField isEqual:_homeTownTextField])
        {
            [_homeTownTextField resignFirstResponder];

        }
    }
    
    return shouldReturn;
    
}

@end
