//
//  CollegeCell.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "College.h"

@interface CollegeCell : UITableViewCell

@property (nonatomic) College *college;
+ (CGFloat)cellHeight;

@end
