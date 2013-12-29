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
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 300, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,(IS_IOS7 ? 0 : -8),0,0);
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor JLGrey];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.textColor = [UIColor whiteColor];
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
