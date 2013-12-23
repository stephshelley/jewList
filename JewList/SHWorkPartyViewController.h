//
//  SHWorkPartyViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextEditViewController.h"
#import "SHToggleButton.h"

@interface SHWorkPartyViewController : SHTextEditViewController <UITextViewDelegate>

@property (nonatomic, strong) SHToggleButton *workButton;
@property (nonatomic, strong) SHToggleButton *playButton;

@end
