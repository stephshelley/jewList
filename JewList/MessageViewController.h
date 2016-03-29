//
//  MessageViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"
#import "UIPlaceHolderTextView.h"

@protocol MessageViewControllerDelegate <NSObject>

- (void)messageViewControllerClose:(NSString *)lastMessage;

@end

@interface MessageViewController : UIViewController

@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) NSString *initialMessage;
@property (nonatomic, strong) User *receipent;
@property (nonatomic, assign) id<MessageViewControllerDelegate> delegate;

- (id)initWithReceipent:(User *)currentUser andMessage:(NSString *)message;


@end
