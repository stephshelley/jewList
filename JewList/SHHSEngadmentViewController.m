//
//  SHHSEngadmentViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHHSEngadmentViewController.h"

@interface SHHSEngadmentViewController ()

@end

@implementation SHHSEngadmentViewController

- (void)loadView
{
    [super loadView];
    
    self.textView.text = self.currentUser.hsEngagement;
    self.textView.delegate = self;
    self.headerLabel.text = @"High School Jewish connections";
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentUser.hsEngagement = textView.text;
    
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
