//
//  SHCollegeCell.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCollegeCell : UITableViewCell

+ (float)rowHeight;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *sepView;

@end
