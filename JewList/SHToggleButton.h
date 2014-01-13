//
//  SHToggleButton.h
//  JewList
//
//  Created by Mihai Chiorean on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHToggleButton : UIButton

@property BOOL isOn;
@property (nonatomic, strong) UIColor *colorOn;
@property (nonatomic, strong) UIColor *colorOff;
@property (nonatomic, strong) NSString *onImage;
@property (nonatomic, strong) NSString *offImage;
@property (nonatomic, strong) UIImageView *buttonImage;

- (void) toggle;
- (void) toggle:(BOOL)isOn;
@end
