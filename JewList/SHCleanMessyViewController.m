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
    CGFloat buttonHeight = 110;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerTopView.bottom + 10, self.view.width,buttonHeight)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.messyButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_messyButton setTitle:@"Messy" forState:UIControlStateNormal];
    [_messyButton setTitle:@"Messy" forState:UIControlStateHighlighted];
    [_messyButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _messyButton.tag = MESSY_BUTTON;
    _messyButton.right = floor(buttonsBackgroundView.width/2);
    _messyButton.centerY = floorf(buttonsBackgroundView.height/2);
    _messyButton.onImage = @"messy_s";
    _messyButton.offImage = @"messy_d";
    [_messyButton toggle:[self.currentUser.cleaning intValue] == 1];
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
    [_cleanButton toggle:[self.currentUser.cleaning intValue] == 0];
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
