//
//  ProfileDetailCellItem.h
//  JewList
//
//  Created by Oren Zitoun on 12/20/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreeTextEnum.h"
#import "MultiSelectionEnum.h"

@interface ProfileDetailCellItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;

@property (nonatomic) FreeTextType freeTextType;
@property (nonatomic) MultiSelectionType multiSelectionType;

@end
