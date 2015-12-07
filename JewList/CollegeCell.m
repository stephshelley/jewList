//
//  CollegeCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "CollegeCell.h"

@interface CollegeCell ()

@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;

@end

@implementation CollegeCell

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setCollege:(College *)college {
    _college = college;
    self.collegeNameLabel.text = _college.collegeName;
}

@end
