//
//  SHDeleteAccountCell.m
//  JewList
//
//  Created by Oren Zitoun on 3/22/14.
//  Copyright (c) 2014 Oren Zitoun. All rights reserved.
//

#import "SHDeleteAccountCell.h"
#import "SHApi.h"

@implementation SHDeleteAccountCell

+ (CGFloat)rowHeight
{
    return 60;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 280, [SHDeleteAccountCell rowHeight] - 20)];
        [_deleteButton setBackgroundColor:UIColorFromRGB(0xfc0d1b)];
        [_deleteButton setTitle:@"Delete account" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:20];
        _deleteButton.titleLabel.textColor = [UIColor whiteColor];
        _deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _deleteButton.centerX = 160;
        _deleteButton.centerY = floorf([SHDeleteAccountCell rowHeight]/2);
        [_deleteButton addTarget:self action:@selector(deletesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];

    }
    
    return self;
    
}

- (void)deletesButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Account" message:@"Are you sure you want to delete your joomie account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[SHApi sharedInstance] deleteAccount];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
