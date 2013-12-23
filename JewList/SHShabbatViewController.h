//
//  SHShabbatViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextEditViewController.h"
#import "SHToggleButton.h"

@interface SHShabbatViewController : SHTextEditViewController <UITextViewDelegate>

@property (nonatomic, strong) SHToggleButton *uberJew;
@property (nonatomic, strong) SHToggleButton *mildJew;
@property (nonatomic, strong) SHToggleButton *mehJew;

@end
