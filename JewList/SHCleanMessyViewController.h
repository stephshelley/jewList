//
//  SHCleanMessyViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextEditViewController.h"
#import "SHToggleButton.h"

@interface SHCleanMessyViewController : SHTextEditViewController <UITextViewDelegate>

@property (nonatomic, strong) SHToggleButton *cleanFreakButton;
@property (nonatomic, strong) SHToggleButton *cleanButton;
@property (nonatomic, strong) SHToggleButton *messyButton;

@end
