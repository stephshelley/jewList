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

@interface MessageViewController () <UIAlertViewDelegate>

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

    UIView *statusBarView = nil;
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    statusBarView.backgroundColor = DEFAULT_BLUE_COLOR;
    statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:statusBarView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    topView.backgroundColor = DEFAULT_BLUE_COLOR;
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [topView addSubview:titleLabel];
    
    UIButton *profileButton = [SHUIHelpers getNavBarButton:CGRectMake(0, 0, 60, 24) title:@"Send" selector:@selector(sendMessage) sender:self];
    profileButton.centerY = titleLabel.centerY;
    profileButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    profileButton.right = topView.width - 10;
    [topView addSubview:profileButton];
    
    UIButton *cancelButton = [SHUIHelpers getNavBarButton:CGRectMake(0, 0, 60, 24) title:@"Cancel" selector:@selector(closeVC) sender:self];
    cancelButton.centerY = titleLabel.centerY;
    cancelButton.left = 10;
    [topView addSubview:cancelButton];

    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, topView.bottom + 20, self.view.width - 20, 200)];
    _textView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
    _textView.placeholder = @"Enter your message here";
    _textView.placeholderColor = [UIColor lightGrayColor];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = YES;
    _textView.editable = YES;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _textView.centerX = floorf(self.view.width/2);
    _textView.clipsToBounds = YES;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    [[SHApi sharedInstance] sendMessage:currentUser recipient:_receipent message:_textView.text success:^(void) {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *alertMessage = [NSString stringWithFormat:@"Your message has successfully sent. Keep an eye out on your email inbox for a response from %@ %@. You’re one step closer to finding your Joomie!”",_receipent.firstName,_receipent.lastName];
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                 message:alertMessage
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             
             [alertView show];
             
         });
     }failure:^(NSError *error)
     {
         [SHUIHelpers alertErrorWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeVCAfterMessageSent];
}
@end
