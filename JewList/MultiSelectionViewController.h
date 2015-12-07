//
//  MultiSelectionViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectionEnum.h"

@protocol MultiSelectionViewControllerDelegate;

@interface MultiSelectionViewController : UIViewController

@property (nonatomic) MultiSelectionType type;
@property (nonatomic) id<MultiSelectionViewControllerDelegate> delegate;

@end

@protocol MultiSelectionViewControllerDelegate <NSObject>

- (void)mutliSelectionViewControllerDidSelect:(MultiSelectionViewController *)viewController value:(NSString *)value;

@end