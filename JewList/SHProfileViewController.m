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
#import "SHUserProfileTextCell.h"
#import "SHTextCellItem.h"

@interface SHProfileViewController ()

@property (nonatomic, assign) CGFloat initialBackdropOriginY;

@end

@implementation SHProfileViewController

- (id)initWithUser:(User*)user
{
    self = [super init];
    if(self)
    {
        User *currentUser = [[SHApi sharedInstance] currentUser];

        self.user = user;
        //user;
        _previousMessage = nil;
        
    }
    
    return self;
    
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Profile";
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;

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
    
    UIView *leftButtonView = [SHUIHelpers getCustomBarButtonView:CGRectMake(0, 0, 44, 44)
                                                     buttonImage:@"iphone_navbar_button_back"
                                                   selectedImage:@"iphone_navbar_button_back"
                                                           title:@""
                                                     andSelector:@selector(popScreen)
                                                          sender:self
                                                      titleColor:[UIColor clearColor]];
    
    leftButtonView.centerY = floorf(topView.height/2);
    leftButtonView.left = 0;
    [topView addSubview:leftButtonView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 24)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:titleLabel.height-2];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.centerX = floorf(topView.width/2);
    titleLabel.centerY = floorf(topView.height/2);
    [topView addSubview:titleLabel];
    
    UIButton *profileButton = [SHUIHelpers getNavBarButton:CGRectMake(0, 0, 60, 24) title:@"Contact" selector:@selector(contactUser) sender:self];

    /*
    UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [profileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [profileButton setTitle:@"Contact" forState:UIControlStateNormal];
    [profileButton setTitle:@"Contact" forState:UIControlStateHighlighted];
    profileButton.titleLabel.textAlignment = NSTextAlignmentRight;
    profileButton.titleLabel.backgroundColor = [UIColor clearColor];
    profileButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:18];
    profileButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    profileButton.backgroundColor = [UIColor clearColor];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
     [profileButton addTarget:self action:@selector(contactUser) forControlEvents:UIControlEventTouchUpInside];
     */
    profileButton.centerY = titleLabel.centerY;
    profileButton.right = topView.width - 10;
    [topView addSubview:profileButton];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.bottom, self.view.width, self.view.height - topView.height - 20)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.delaysContentTouches = YES;
    _scrollView.canCancelContentTouches = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, 1000);
    [self.view addSubview:_scrollView];
    if(IS_IOS7)
        [self.view insertSubview:_scrollView belowSubview:statusBarView];
    
    self.backdropView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, topView.bottom - 20, _scrollView.width, (IsIpad ? 350 : 240))];
    _backdropView.backgroundColor = [UIColor clearColor];
    _initialBackdropOriginY = _backdropView.top;
    [self.view addSubview:_backdropView];
    [self.view sendSubviewToBack:_backdropView];

    
    
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backdropView.width, _backdropView.height)];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.4;
    [_backdropView addSubview:overlay];
    
    self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _userImageView.centerX = floorf(_backdropView.width/2);
    _userImageView.centerY = floorf(_backdropView.height/2);
    _userImageView.backgroundColor = [UIColor clearColor];
    [_backdropView addSubview:_userImageView];
    [_userImageView setUserImagePathToNetworkImage:[_user fbImageUrlForSize:_userImageView.size] forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];

    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Contact" style:UIBarButtonItemStylePlain target:self action:@selector(contactUser)];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 40,24)];
    _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.centerX = _userImageView.centerX;
    _nameLabel.bottom = _userImageView.top - 10;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = [NSString stringWithFormat:@"%@",_user.firstName];
    [_backdropView addSubview:_nameLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _nameLabel.width,20)];
    _detailLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_detailLabel.height-2)];
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.centerX = _nameLabel.centerX;
    _detailLabel.top = _userImageView.bottom + 10;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = [NSString stringWithFormat:@"%@, %d, Class of %d",[self getGenderSign],[_user.age integerValue] ,[_user.gradYear integerValue]];
    [_backdropView addSubview:_detailLabel];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _backdropView.bottom - 65, self.view.width, self.view.height)];
    _tableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    [_tableView registerClass:[SHUserProfileTextCell class] forCellReuseIdentifier:NSStringFromClass([SHUserProfileTextCell class])];
    [_scrollView addSubview:_tableView];
    
    
    //[self loadUserDetails];
    [self loadCover];
    [self loadItems];
    
}

- (void)loadItems
{
    _items = nil;
    _items = [NSMutableArray array];
    
    if(_user.aboutMe != nil && _user.aboutMe.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"About Me";
        item.text = _user.aboutMe;
        [_items addObject:item];
        
    }
    
    if(_user.hsEngagement != nil && _user.hsEngagement.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"High school engagement";
        item.text = _user.hsEngagement;
        [_items addObject:item];
        
    }
    
    if(_user.personalityText != nil && _user.personalityText.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"Work/Party";
        item.text = _user.roommatePrefs;
        item.type = [_user.personality intValue]  == 0 ? @"Work" : @"Play";
        [_items addObject:item];
        
    }
    
    if(_user.cleaningText != nil && _user.cleaningText.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"Clean/Messy";
        item.text = _user.cleaningText;
        item.type = [_user.cleaning intValue]  == 0 ? @"Clean" : @"Messy";

        [_items addObject:item];
        
    }
    
    if(_user.dietText != nil && _user.dietText.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"Diet";
        item.text = _user.dietText;
        item.type = [_user.diet intValue]  == 0 ? @"Non Kosher" : @"Kosher";

        [_items addObject:item];
        
    }
    
    if(_user.religiousText != nil && _user.religiousText.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"How jew are you?";
        item.text = _user.religiousText;
        
        if([_user.religious intValue]  == 0)
        {
            item.type = @"Uber";
        }else if([_user.religious intValue]  == 1)
        {
            item.type = @"Mild";
        }else if([_user.religious intValue]  == 2)
        {
            item.type = @"Meh";
        }
        
        [_items addObject:item];
        
    }
    
    if(_user.roommatePrefs != nil && _user.roommatePrefs.length > 0)
    {
        SHTextCellItem *item = [[SHTextCellItem alloc] init];
        item.title = @"What i want in a roomate";
        item.text = _user.roommatePrefs;
        [_items addObject:item];
        
    }
    
    [self refreshTableHeight];
    [_tableView reloadData];
    
}


- (void)loadCover
{
    //User *currentUser = [[SHApi sharedInstance] currentUser];
    __weak __typeof(&*self)weakSelf = self;

    [[SHApi sharedInstance] getCoverUrl:_user.fb success:^(NSString *url)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.backdropView setPathToNetworkImage:url forDisplaySize:weakSelf.backdropView.size contentMode:UIViewContentModeScaleAspectFill];

         });
     }failure:^(NSError *error)
     {
         
     }];
}


- (void)contactUser
{
    MessageViewController *vc = [[MessageViewController alloc] initWithReceipent:_user andMessage:_previousMessage];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)refreshTableHeight
{
    CGFloat height = 0;

    for(id object in _items)
    {
        if([object isKindOfClass:[SHTextCellItem class]])
        {
            SHTextCellItem *item = (SHTextCellItem *)object;
            height+= [item getCellHeight];
            
        }
        
    }
    
    
    _tableView.height = height;
    
    height = (_tableView.height + _tableView.top > self.view.height) ? _tableView.height + _tableView.top : self.view.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, height);
    
}

- (void)updateOffsets
{
    CGFloat yOffset   = self.scrollView.contentOffset.y;
    _backdropView.top = _initialBackdropOriginY - floorf(yOffset/4);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateOffsets];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    id object = [_items objectAtIndex:indexPath.row];
    if([object isKindOfClass:[SHTextCellItem class]])
    {
        SHTextCellItem *item = (SHTextCellItem *)object;
        height = [item getCellHeight];
        
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id object = [_items objectAtIndex:indexPath.row];
    if([object isKindOfClass:[SHTextCellItem class]])
    {
        SHTextCellItem *item = (SHTextCellItem *)object;
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHUserProfileTextCell class])];
        SHUserProfileTextCell *profileTextCell = (SHUserProfileTextCell *)cell;
        profileTextCell.item = item;
        
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


#pragma mark - MessageViewControllerDelegate -
- (void)messageViewControllerClose:(NSString *)lastMessage
{
    _previousMessage = lastMessage;
    
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

@end
