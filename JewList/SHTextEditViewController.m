//
//  SHTextEditViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextEditViewController.h"
#import "JLColors.h"

@interface SHTextEditViewController ()

@end

@implementation SHTextEditViewController

- (id)initWithUser:(User *)currentUser
{
    self = [super init];
    if(self)
    {
        _currentUser = currentUser;
        
    }
    
    return self;
    
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    _headerTopView.backgroundColor = [UIColor JLGrey];
    [self.view addSubview:_headerTopView];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerTopView.width, _headerTopView.height)];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    [_headerTopView addSubview:_headerLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, _headerTopView.bottom + 5, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor JLGrey];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.view.width/2);
    _textView.clipsToBounds = YES;
    [self.view addSubview:_textView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_textView becomeFirstResponder];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
