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

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DEFAULT_BLUE_COLOR;
    if(IS_IOS7) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:topView];
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popVC)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(topView.height/2);
    leftButtonView.left = 0;
    [topView addSubview:leftButtonView];
        
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, self.view.height-topView.height)];
    whiteBgView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self.view addSubview:whiteBgView];
    
    self.headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, 50)];
    _headerTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerTopView];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerTopView.width - 20, _headerTopView.height)];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    _headerLabel.textColor = DEFAULT_BLUE_COLOR;
    _headerLabel.adjustsFontSizeToFitWidth = YES;
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.centerX = floorf(_headerTopView.width/2);
    [_headerTopView addSubview:_headerLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, _headerTopView.bottom + 5, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.textColor = [UIColor blackColor];
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
