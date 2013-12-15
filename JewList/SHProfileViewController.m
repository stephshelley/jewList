//
//  SHProfileViewController.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHProfileViewController.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import "SHUIHelpers.h"
#import "SHApi.h"

@implementation SHProfileViewController

- (id)initWithUser:(User*)user
{
    self = [super init];
    if(self)
    {
        self.user = user;
    }
    
    return self;
    
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Profile";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];

    leftButtonView.top = IS_IOS7 ? 20 : 0;
    leftButtonView.left = 0;
    [self.view addSubview:leftButtonView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 40,24)];
    _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.centerX = floorf(self.view.width/2);
    _nameLabel.top = 10 + (IS_IOS7 ? 20 : 0);
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
    [self.view addSubview:_nameLabel];
    
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _userImageView.centerX = _nameLabel.centerX;
    _userImageView.top = _nameLabel.bottom + 10;
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImageView.layer.borderWidth = 2.0;
    [self.view addSubview:_userImageView];

    [_userImageView setPathToNetworkImage:_user.fbImageUrl forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _nameLabel.width,20)];
    _detailLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_detailLabel.height-2)];
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.centerX = _nameLabel.centerX;
    _detailLabel.top = _userImageView.bottom + 10;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = [NSString stringWithFormat:@"%@, %@, %@",[self getGenderSign],SAFE_VAL(_user.age) ,_user.fbHometownName];
    [self.view addSubview:_detailLabel];

    [self loadUserDetails];
    
}

- (void)loadUserDetails
{
    UIView *detailsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _detailLabel.bottom + 10, self.view.width, self.view.height - (_detailLabel.bottom))];
    detailsBackgroundView.backgroundColor = [UIColor whiteColor];
    detailsBackgroundView.layer.borderColor = UIColorFromRGB(0x7a7a7a).CGColor;
    detailsBackgroundView.layer.borderWidth = 2;
    [self.view addSubview:detailsBackgroundView];
    
    self.kosherStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,80,17)];
    _kosherStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_kosherStaticLabel.height-2)];
    _kosherStaticLabel.textColor = UIColorFromRGB(0x7a7a7a);
    _kosherStaticLabel.centerX = 53;
    _kosherStaticLabel.top = 10;
    _kosherStaticLabel.adjustsFontSizeToFitWidth = YES;
    _kosherStaticLabel.backgroundColor = [UIColor clearColor];
    _kosherStaticLabel.textAlignment = NSTextAlignmentCenter;
    _kosherStaticLabel.text = @"Kosher";
    [detailsBackgroundView addSubview:_kosherStaticLabel];
    
    self.kosherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _kosherImageView.backgroundColor = [UIColor redColor];
    _kosherImageView.top = _kosherStaticLabel.bottom + 5;
    _kosherImageView.centerX = _kosherStaticLabel.centerX;
    [detailsBackgroundView addSubview:_kosherImageView];
    
    self.kosherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _kosherLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_kosherLabel.height-2)];
    _kosherLabel.textColor = UIColorFromRGB(0x7a7a7a);
    _kosherLabel.centerX = _kosherImageView.centerX;
    _kosherLabel.top = _kosherImageView.bottom + 5;
    _kosherLabel.adjustsFontSizeToFitWidth = YES;
    _kosherLabel.backgroundColor = [UIColor clearColor];
    _kosherLabel.textAlignment = NSTextAlignmentCenter;
    _kosherLabel.text = _user.kosher;
    [detailsBackgroundView addSubview:_kosherLabel];
    
    self.shabatStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,80,17)];
    _shabatStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_shabatStaticLabel.height-2)];
    _shabatStaticLabel.textColor = UIColorFromRGB(0x7a7a7a);
    _shabatStaticLabel.centerX = floor(self.view.width/2);
    _shabatStaticLabel.top = _kosherStaticLabel.top;
    _shabatStaticLabel.adjustsFontSizeToFitWidth = YES;
    _shabatStaticLabel.backgroundColor = [UIColor clearColor];
    _shabatStaticLabel.textAlignment = NSTextAlignmentCenter;
    _shabatStaticLabel.text = @"Shabat";
    [detailsBackgroundView addSubview:_shabatStaticLabel];
    
    self.shabatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _shabatImageView.backgroundColor = [UIColor redColor];
    _shabatImageView.top = _shabatStaticLabel.bottom + 5;
    _shabatImageView.centerX = _shabatStaticLabel.centerX;
    [detailsBackgroundView addSubview:_shabatImageView];
    
    self.shabatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _shabatLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_shabatLabel.height-2)];
    _shabatLabel.textColor = UIColorFromRGB(0x7a7a7a);
    _shabatLabel.centerX = _shabatImageView.centerX;
    _shabatLabel.top = _shabatImageView.bottom + 5;
    _shabatLabel.adjustsFontSizeToFitWidth = YES;
    _shabatLabel.backgroundColor = [UIColor clearColor];
    _shabatLabel.textAlignment = NSTextAlignmentCenter;
    _shabatLabel.text = _user.shabat;
    [detailsBackgroundView addSubview:_shabatLabel];
        
    self.facebookStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,17)];
    _facebookStaticLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_facebookStaticLabel.height-2)];
    _facebookStaticLabel.textColor = UIColorFromRGB(0x7a7a7a);
    _facebookStaticLabel.centerX = 266;
    _facebookStaticLabel.top = _shabatStaticLabel.top;
    _facebookStaticLabel.adjustsFontSizeToFitWidth = YES;
    _facebookStaticLabel.backgroundColor = [UIColor clearColor];
    _facebookStaticLabel.textAlignment = NSTextAlignmentCenter;
    _facebookStaticLabel.text = @"Facebook Profile";
    [detailsBackgroundView addSubview:_facebookStaticLabel];
    
    self.facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _facebookButton.backgroundColor = DEFAULT_BLUE_COLOR;
    _facebookButton.centerY = _shabatImageView.centerY;
    _facebookButton.centerX = _facebookStaticLabel.centerX;
    [_facebookButton addTarget:self action:@selector(facebookButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [detailsBackgroundView addSubview:_facebookButton];
    
    UIView *bottomSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 2)];
    bottomSepView.backgroundColor = UIColorFromRGB(0x7a7a7a);
    bottomSepView.top = _shabatLabel.bottom;
    [detailsBackgroundView addSubview:bottomSepView];

    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, bottomSepView.top)];
    sep1.backgroundColor = UIColorFromRGB(0x7a7a7a);
    sep1.left = 106;
    [detailsBackgroundView addSubview:sep1];

    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, sep1.height)];
    sep2.backgroundColor = UIColorFromRGB(0x7a7a7a);
    sep2.left = 106*2;
    [detailsBackgroundView addSubview:sep2];

    self.wordsDefinesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 20, 20)];
    _wordsDefinesLabel.centerX = floor(self.view.width/2);
    _wordsDefinesLabel.text = [NSString stringWithFormat:@"Words that define %@:",_user.firstName];
    _wordsDefinesLabel.top = bottomSepView.bottom + 5;
    _wordCloudTextView.textColor = DEFAULT_BLUE_COLOR;
    _wordsDefinesLabel.textAlignment = NSTextAlignmentCenter;
    [detailsBackgroundView addSubview:_wordsDefinesLabel];
    
    self.wordCloudTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _wordsDefinesLabel.width, detailsBackgroundView.height - _wordsDefinesLabel.bottom - 60)];
    _wordCloudTextView.font = [UIFont fontWithName:DEFAULT_FONT size:16];
    _wordCloudTextView.textColor = DEFAULT_BLUE_COLOR;
    _wordCloudTextView.textAlignment = NSTextAlignmentLeft;
    _wordCloudTextView.top = _wordsDefinesLabel.bottom + 5;
    _wordCloudTextView.centerX = _wordsDefinesLabel.centerX;
    _wordCloudTextView.backgroundColor = [UIColor clearColor];
    _wordCloudTextView.editable = NO;
    _wordCloudTextView.userInteractionEnabled = YES;
    [detailsBackgroundView addSubview:_wordCloudTextView];
    _wordCloudTextView.text = @"Surfing, Basketball, Concerts, Programming, Hummus!";
 
    CGFloat buttonHeight = 63;
    self.nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, detailsBackgroundView.height-buttonHeight, detailsBackgroundView.width, buttonHeight)];
    _nextStepButton.backgroundColor = DEFAULT_BLUE_COLOR;
    [_nextStepButton setTitle:[NSString stringWithFormat:@"Contact %@",_user.firstName] forState:UIControlStateNormal];
    _nextStepButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:24];
    _nextStepButton.bottom = detailsBackgroundView.height - 10;
    [_nextStepButton addTarget:self action:@selector(contactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _nextStepButton.titleLabel.textColor = [UIColor whiteColor];
    _nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [detailsBackgroundView addSubview:_nextStepButton];
}

- (void)contactButtonPressed
{
    if ([MFMailComposeViewController canSendMail])
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Shalom from %@",currentUser.firstName]];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"oren.zitoun@gmail.com", nil];
//        NSArray *toRecipients = [NSArray arrayWithObjects:_user.email, nil];
        [mailer setToRecipients:toRecipients];
        UIImage *myImage = [UIImage imageNamed:@"muchsmaller.png"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        NSString *emailBody = [NSString stringWithFormat:@"Hi %@,\n%@ noticed that you're about to go to %@.\n\n He's looking for a roomate and wanted to contact you",_user.firstName,currentUser.firstName,_user.fbCollegeName];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self.navigationController presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)facebookButtonPressed
{
    
}

- (NSString*)getGenderSign
{
    NSString *gender = nil;
    
    if([_user.gender intValue] == 0)
    {
        gender = @"M";
    }else if([_user.gender intValue] == 1)
    {
        gender = @"F";
    }else{
        gender = @"";
    }
    
    return gender;
}


- (void)popScreen
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
