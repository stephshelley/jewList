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
    
    UIView *userTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
    userTopView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:userTopView];
    
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _userImageView.backgroundColor = [UIColor redColor];
    _userImageView.left = 10;
    _userImageView.top = 10;
    [_userImageView setPathToNetworkImage:_user.fbImageUrl forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_userImageView];
    
    self.hiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.right + 10, _userImageView.top + 2, self.width - 10 - (_userImageView.right + 10), 24)];
    _hiLabel.textAlignment = NSTextAlignmentLeft;
    _hiLabel.font = [UIFont fontWithName:DEFAULT_FONT size:_hiLabel.height-2];
    _hiLabel.textColor = [UIColor whiteColor];
    _hiLabel.backgroundColor = [UIColor grayColor];
    _hiLabel.text = [NSString stringWithFormat:@"Hi %@!",_user.firstName];
    [self addSubview:_hiLabel];
    
    self.letsGoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hiLabel.left, _hiLabel.bottom, _hiLabel.width, 40)];
    _letsGoLabel.textAlignment = NSTextAlignmentLeft;
    _letsGoLabel.font = [UIFont fontWithName:DEFAULT_FONT size:(_letsGoLabel.height/2)-4];
    _letsGoLabel.textColor = [UIColor whiteColor];
    _letsGoLabel.backgroundColor = [UIColor grayColor];
    _letsGoLabel.numberOfLines = 2;
    _letsGoLabel.text = @"Let's just make sure you are ok with the info we got on you";
    [self addSubview:_letsGoLabel];
    
    UIView *nameBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, userTopView.bottom + 10, self.width - 40, 40)];
    nameBackground.backgroundColor = DEFAULT_BLUE_COLOR;
    nameBackground.centerX = userTopView.centerX;
    [self addSubview:nameBackground];
    
    self.nameTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(0, 0, nameBackground.width - 20, 30)];
    _nameTextField.placeholder = @"Your Name";
    _nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    _nameTextField.centerX = floor(nameBackground.width/2);
    _nameTextField.centerY = floor(nameBackground.height/2);
    [nameBackground addSubview:_nameTextField];

    UIView *homeBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, nameBackground.bottom + 10, nameBackground.width, nameBackground.height)];
    homeBackground.backgroundColor = DEFAULT_BLUE_COLOR;
    homeBackground.centerX = nameBackground.centerX;
    [self addSubview:homeBackground];
    
    self.homeTownTextField = [[SHTextFieldOnBoarding alloc] initWithFrame:CGRectMake(0, 0, nameBackground.width - 20, 30)];
    _homeTownTextField.placeholder = @"Home Town";
    _homeTownTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _homeTownTextField.returnKeyType = UIReturnKeyNext;
    _homeTownTextField.delegate = self;
    _homeTownTextField.centerX = floor(homeBackground.width/2);
    _homeTownTextField.centerY = floor(homeBackground.height/2);
    [homeBackground addSubview:_homeTownTextField];
    
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    _nextStepButton.backgroundColor = [UIColor blueColor];
    _nextStepButton.bottom = self.height - 20;
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next Step" forState:UIControlStateHighlighted];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _nextStepButton.centerX = userTopView.centerX;
    [self addSubview:_nextStepButton];
    
    _nameTextField.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
    _homeTownTextField.text = SAFE_VAL(_user.fbHometownName);
    
    UIView *genderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 40, 120)];
    genderBackgroundView.backgroundColor = DEFAULT_BLUE_COLOR_ALPHA(0.9);
    genderBackgroundView.left = 20;
    genderBackgroundView.bottom = _nextStepButton.top - 20;
    [self addSubview:genderBackgroundView];
    
    self.femaleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 100)];
    _femaleButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_femaleButton setTitle:@"Female" forState:UIControlStateNormal];
    [_femaleButton setTitle:@"Female" forState:UIControlStateHighlighted];
    _femaleButton.tag = 1;
    _femaleButton.top = 10;
    _femaleButton.right = floor(genderBackgroundView.width/2);
    [_femaleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_femaleButton];
 
    self.maleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _femaleButton.width, _femaleButton.height)];
    _maleButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_maleButton setTitle:@"Male" forState:UIControlStateNormal];
    [_maleButton setTitle:@"Male" forState:UIControlStateHighlighted];
    _maleButton.tag = 0;
    _maleButton.top = _femaleButton.top;
    _maleButton.left = _femaleButton.right+1;
    [_maleButton addTarget:self action:@selector(genderTogglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [genderBackgroundView addSubview:_maleButton];

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
