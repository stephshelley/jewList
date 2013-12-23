//
//  SHAboutMeViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHAboutMeViewController.h"

@interface SHAboutMeViewController ()

@end

@implementation SHAboutMeViewController

- (void)loadView
{
    [super loadView];
    
    self.textView.text = self.currentUser.aboutMe;
    self.textView.delegate = self;
    self.headerLabel.text = @"Short text about you";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.aboutMe = textView.text;
    
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
