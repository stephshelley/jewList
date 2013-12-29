//
//  SHProfileViewController.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "NINetworkImageView.h"
#import <MessageUI/MessageUI.h>
#import "MessageViewController.h"

@class User;

@interface SHProfileViewController : UIViewController <MFMailComposeViewControllerDelegate,MessageViewControllerDelegate,NINetworkImageViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic, strong) NINetworkImageView *userImageView;
@property (nonatomic, strong) NINetworkImageView *backdropView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *previousMessage;
@property (nonatomic, strong) NSMutableArray *items;





@property (nonatomic, strong) UILabel *kosherStaticLabel;
@property (nonatomic, strong) UILabel *kosherLabel;
@property (nonatomic, strong) UIImageView *kosherImageView;

@property (nonatomic, strong) UILabel *shabatStaticLabel;
@property (nonatomic, strong) UILabel *shabatLabel;
@property (nonatomic, strong) UIImageView *shabatImageView;

@property (nonatomic, strong) UILabel *facebookStaticLabel;
@property (nonatomic, strong) UIButton *facebookButton;

@property (nonatomic, strong) UILabel *wordsDefinesLabel;
@property (nonatomic, strong) UITextView *wordCloudTextView;

@property (nonatomic, strong) UIButton *nextStepButton;

- (id)initWithUser:(User*)user;

@end
