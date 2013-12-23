//
//  SHDietViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextEditViewController.h"
#import "SHToggleButton.h"

@interface SHDietViewController : SHTextEditViewController <UITextViewDelegate>

@property (nonatomic, strong) SHToggleButton *kosherButton;
@property (nonatomic, strong) SHToggleButton *nonKosherButton;

@end
