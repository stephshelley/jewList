//
//  SHDeleteAccountCell.h
//  JewList
//
//  Created by Oren Zitoun on 3/22/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDeleteAccountCell : UITableViewCell <UIAlertViewDelegate>

@property (nonatomic ,strong) UIButton *deleteButton;
+ (CGFloat)rowHeight;

@end
