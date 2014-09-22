//
//  SHWhatIWantInARoomateViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHWhatIWantInARoomateViewController.h"

@interface SHWhatIWantInARoomateViewController ()

@end

@implementation SHWhatIWantInARoomateViewController

- (void)loadView
{
    [super loadView];
    
    self.textView.text = self.currentUser.roommatePrefs;
    self.textView.delegate = self;
    self.headerLabel.text = @"What are you looking for in a roommate?";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.roommatePrefs = textView.text;
    
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
