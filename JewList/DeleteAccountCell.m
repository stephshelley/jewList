//
//  DeleteAccountCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/27/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "DeleteAccountCell.h"
#import "SHUIHelpers.h"
#import "UIView+FindUIViewController.h"
#import "SHApi.h"

@implementation DeleteAccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)onDeleteAccountButton:(id)sender {
    
    UIAlertController *controller = [SHUIHelpers alertControllerWithTitle:@"Delete Account" message:@"Are you sure you want to delete your joomie account?" buttonTitles:@[@"Yes"] completion:^(NSString *selectedButtonTitle) {
        
        if ([selectedButtonTitle isEqualToString:@"Yes"]) {
            [[SHApi sharedInstance] deleteAccount];
        }
        
    }];
    
    UIViewController *firstVC = [self firstAvailableUIViewController];
    [firstVC presentViewController:controller animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
