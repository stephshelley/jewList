//
//  FreeTextViewController.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeTextEnum.h"

@class  User;
@protocol FreeTextViewControllerDelegate;

@interface FreeTextViewController : UIViewController

@property (nonatomic) FreeTextType type;
@property (nonatomic) id<FreeTextViewControllerDelegate> delegate;

@property (nonatomic) BOOL saveOnBackButton;
@property (nonatomic) NSString *preloadText;

@end

@protocol FreeTextViewControllerDelegate <NSObject>

- (void)freeTextControllerDidChooseText:(FreeTextViewController *)viewController text:(NSString *)text;

@end