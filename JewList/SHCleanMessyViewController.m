//
//  SHCleanMessyViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHCleanMessyViewController.h"
#import "JLColors.h"

#define CLEAN_BUTTON 0
#define MESSY_BUTTON 1

@interface SHCleanMessyViewController ()

@end

@implementation SHCleanMessyViewController

- (void)loadView
{
    [super loadView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.currentUser.cleaningText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Are you more a clean or messy person?";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.cleaningText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 60;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,80)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.messyButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_messyButton setColorOff:[UIColor grayColor]];
    [_messyButton setColorOn:DEFAULT_BLUE_COLOR];
    [_messyButton setTitle:@"Messy" forState:UIControlStateNormal];
    [_messyButton setTitle:@"Messy" forState:UIControlStateHighlighted];
    [_messyButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _messyButton.tag = MESSY_BUTTON;
    _messyButton.right = floor(buttonsBackgroundView.width/2) - 10;
    _messyButton.top = 0;
    [_messyButton toggle:[self.currentUser.cleaning intValue] == 1];
    [_messyButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_messyButton];
    
    UIImageView *femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    femaleImage.image = [UIImage imageNamed:@"girlfinal"];
    femaleImage.centerX = floorf(_messyButton.width/2);
    femaleImage.centerY = floorf(_messyButton.height/2);
    femaleImage.userInteractionEnabled = NO;
    [_messyButton addSubview:femaleImage];
    
    self.cleanButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_messyButton.right +2, _messyButton.top, _messyButton.width, _messyButton.height)];
    [_cleanButton setColorOff:[UIColor grayColor]];
    [_cleanButton setColorOn:DEFAULT_BLUE_COLOR];
    _cleanButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
    [_cleanButton setTitle:@"Clean" forState:UIControlStateHighlighted];
    [_cleanButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _cleanButton.tag = CLEAN_BUTTON;
    _cleanButton.top = _messyButton.top;
    _cleanButton.left = _messyButton.right + 20;
    [_cleanButton toggle:[self.currentUser.cleaning intValue] == 0];
    [_cleanButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_cleanButton];
    
    
    UIImageView *boyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    boyImage.image = [UIImage imageNamed:@"boyfinal"];
    boyImage.centerX = floorf(_cleanButton.width/2);
    boyImage.centerY = floorf(_cleanButton.height/2);
    boyImage.userInteractionEnabled = NO;
    [_cleanButton addSubview:boyImage];
    
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
        self.currentUser.cleaning = @1;
        
    }
    else if(senderButton.tag == CLEAN_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.cleaning = @0;
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
