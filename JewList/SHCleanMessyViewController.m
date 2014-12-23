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
#define CLEAN_FREAK_BUTTON 2

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
    CGFloat buttonHeight = 88;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.view.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.cleanButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
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
    [_cleanButton toggle:[self.currentUser.cleaning intValue] == 1];
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
    [_cleanFreakButton toggle:[self.currentUser.cleaning intValue] == 2];
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
    [_messyButton toggle:[self.currentUser.cleaning intValue] == 0];
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
        self.currentUser.cleaning = @0;
        
    }
    else if(senderButton.tag == CLEAN_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        [_cleanFreakButton toggle:NO];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanFreakButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.cleaning = @1;
        
    }
    else if(senderButton.tag == CLEAN_FREAK_BUTTON && [senderButton isOn])
    {
        [_messyButton toggle:NO];
        [_cleanButton toggle:NO];
        _messyButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanButton.titleLabel.textColor = [UIColor darkGrayColor];
        _cleanFreakButton.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.cleaning = @2;
        
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
