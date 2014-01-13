//
//  SHDietViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHDietViewController.h"
#import "JLColors.h"

#define KOSHER_BUTTON 0
#define NON_KOSHER_BUTTON 1

@interface SHDietViewController ()

@end

@implementation SHDietViewController

- (void)loadView
{
    [super loadView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.currentUser.dietText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Do you keep kosher?";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.dietText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 60;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,80)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.nonKosherButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight + 20, buttonHeight)];
    [_nonKosherButton setColorOff:[UIColor grayColor]];
    [_nonKosherButton setColorOn:DEFAULT_BLUE_COLOR];
    [_nonKosherButton setTitle:@"Non Kosher" forState:UIControlStateNormal];
    [_nonKosherButton setTitle:@"Non Kosher" forState:UIControlStateHighlighted];
    [_nonKosherButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _nonKosherButton.tag = NON_KOSHER_BUTTON;
    _nonKosherButton.right = floor(buttonsBackgroundView.width/2) - 10;
    _nonKosherButton.top = 0;
    _nonKosherButton.onImage = @"nonkosher_s";
    _nonKosherButton.offImage = @"nonkosher_d";
    _nonKosherButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:14];
    _nonKosherButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_nonKosherButton toggle:[self.currentUser.diet intValue] == 1];
    [_nonKosherButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_nonKosherButton];
   
    self.kosherButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_nonKosherButton.right +2, _nonKosherButton.top, _nonKosherButton.width, _nonKosherButton.height)];
    [_kosherButton setColorOff:[UIColor grayColor]];
    [_kosherButton setColorOn:DEFAULT_BLUE_COLOR];
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
    _kosherButton.left = _nonKosherButton.right + 20;
    [_kosherButton toggle:[self.currentUser.diet intValue] == 0];
    [_kosherButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_kosherButton];
    
    
    UIImageView *boyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    boyImage.image = [UIImage imageNamed:@"boyfinal"];
    boyImage.centerX = floorf(_kosherButton.width/2);
    boyImage.centerY = floorf(_kosherButton.height/2);
    boyImage.userInteractionEnabled = NO;
    [_kosherButton addSubview:boyImage];
    
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
        self.currentUser.diet = @1;
        
    }
    else if(senderButton.tag == KOSHER_BUTTON && [senderButton isOn])
    {
        [_nonKosherButton toggle:NO];
        _nonKosherButton.titleLabel.textColor = [UIColor darkGrayColor];
        _kosherButton.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.diet = @0;
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
