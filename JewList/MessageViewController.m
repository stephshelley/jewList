//
//  MessageViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "MessageViewController.h"
#import "JLColors.h"
#import "SHApi.h"
#import "SHUIHelpers.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithReceipent:(User *)user andMessage:(NSString *)message
{
    self = [super init];
    if(self)
    {
        self.receipent = user;
        self.initialMessage = message;
        
    }
    
    return self;
    
}

- (void)closeVC
{
    if(_delegate && [_delegate respondsToSelector:@selector(messageViewControllerClose:)])
        [_delegate messageViewControllerClose:_textView.text];
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)closeVCAfterMessageSent
{
    if(_delegate && [_delegate respondsToSelector:@selector(messageViewControllerClose:)])
        [_delegate messageViewControllerClose:@""];
    
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)loadView
{
    [super loadView];
    self.title = [NSString stringWithFormat:@"Message %@",_receipent.firstName];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.navigationController.navigationBarHidden = YES;

    UIView *statusBarView = nil;
    if(IS_IOS7)
    {
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        statusBarView.backgroundColor = DEFAULT_BLUE_COLOR;
        [self.view addSubview:statusBarView];
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    [self.view addSubview:topView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 24)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:titleLabel.height-4];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.centerX = floorf(topView.width/2);
    titleLabel.centerY = floorf(topView.height/2);
    [topView addSubview:titleLabel];
    
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [profileButton setTitle:@"Send" forState:UIControlStateNormal];
    [profileButton setTitle:@"Send" forState:UIControlStateHighlighted];
    profileButton.titleLabel.textAlignment = NSTextAlignmentRight;
    profileButton.titleLabel.backgroundColor = [UIColor clearColor];
    profileButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    profileButton.backgroundColor = [UIColor clearColor];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    profileButton.centerY = titleLabel.centerY;
    profileButton.right = topView.width - 10;
    [profileButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:profileButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    cancelButton.titleLabel.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
    cancelButton.centerY = titleLabel.centerY;
    cancelButton.left = 0;
    [cancelButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, topView.bottom + 20, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.view.width/2);
    _textView.clipsToBounds = YES;
    _textView.text = _initialMessage;
    [self.view addSubview:_textView];
    
}

- (void)sendMessage
{
    if(_textView.text.length == 0)
    {
        [SHUIHelpers alertErrorWithMessage:@"Message is empty"];
        return;
    }
    
    User *currentUser = [[SHApi sharedInstance] currentUser];
    __weak __typeof(&*self)weakSelf = self;

    [[SHApi sharedInstance] sendMessage:currentUser recipient:_receipent message:_textView.text success:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf closeVCAfterMessageSent];
             
         });
     }failure:^(NSError *error)
     {

     }];
    
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
