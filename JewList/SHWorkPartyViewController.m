//
//  SHWorkPartyViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHWorkPartyViewController.h"
#import "JLColors.h"

#define WORK_BUTTON 0
#define PLAY_BUTTON 1

@interface SHWorkPartyViewController ()

@end

@implementation SHWorkPartyViewController

- (void)loadView
{
    [super loadView];
    
    UIView *buttonsView = [self toggleView];
    
    buttonsView.top = self.headerTopView.bottom + 10;
    self.textView.top = buttonsView.bottom + 10;
    
    self.textView.text = self.currentUser.personalityText;
    self.textView.height = 100;
    self.textView.delegate = self;
    self.headerLabel.text = @"Are you more a party or work kind of person?";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.personalityText = textView.text;
    
}

- (UIView *)toggleView
{
    CGFloat buttonHeight = 60;
    
    UIView *buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,80)];
    buttonsBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:buttonsBackgroundView];
    
    self.playButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(self.view.width/2 - (buttonHeight*2 +2)/2,0, buttonHeight, buttonHeight)];
    [_playButton setColorOff:[UIColor grayColor]];
    [_playButton setColorOn:DEFAULT_BLUE_COLOR];
    [_playButton setTitle:@"Party" forState:UIControlStateNormal];
    [_playButton setTitle:@"Party" forState:UIControlStateHighlighted];
    [_playButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _playButton.tag = PLAY_BUTTON;
    _playButton.right = floor(buttonsBackgroundView.width/2) - 10;
    _playButton.top = 0;
    [_playButton toggle:[self.currentUser.personality intValue] == 1];
    [_playButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_playButton];
    
    UIImageView *femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    femaleImage.image = [UIImage imageNamed:@"girlfinal"];
    femaleImage.centerX = floorf(_playButton.width/2);
    femaleImage.centerY = floorf(_playButton.height/2);
    femaleImage.userInteractionEnabled = NO;
    [_playButton addSubview:femaleImage];
    
    self.workButton = [[SHToggleButton alloc] initWithFrame:CGRectMake(_playButton.right +2, _playButton.top, _playButton.width, _playButton.height)];
    [_workButton setColorOff:[UIColor grayColor]];
    [_workButton setColorOn:DEFAULT_BLUE_COLOR];
    _workButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_workButton setTitle:@"Work" forState:UIControlStateNormal];
    [_workButton setTitle:@"Work" forState:UIControlStateHighlighted];
    [_workButton setTitleEdgeInsets:UIEdgeInsetsMake(90, 0, 0, 0)];
    _workButton.tag = WORK_BUTTON;
    _workButton.top = _playButton.top;
    _workButton.left = _playButton.right + 20;
    [_workButton toggle:[self.currentUser.personality intValue] == 0];
    [_workButton addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsBackgroundView addSubview:_workButton];
    
    
    UIImageView *boyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    boyImage.image = [UIImage imageNamed:@"boyfinal"];
    boyImage.centerX = floorf(_workButton.width/2);
    boyImage.centerY = floorf(_workButton.height/2);
    boyImage.userInteractionEnabled = NO;
    [_workButton addSubview:boyImage];

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
        self.currentUser.personality = @1;
        
    }
    else if(senderButton.tag == WORK_BUTTON && [senderButton isOn])
    {
        [_playButton toggle:NO];
        _playButton.titleLabel.textColor = [UIColor darkGrayColor];
        _workButton.titleLabel.textColor = [UIColor whiteColor];
        self.currentUser.personality = @0;
        
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
