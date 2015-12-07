//
//  MultiSelectionPresenter.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface MultiSelectionPresenter : NSObject

+ (instancetype)presenterFromViewController:(UIViewController *)fromViewController user:(User *)user;
- (void)present;

@end
