//
//  SHUserCellItem.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@interface SHUserCellItem : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL selected;

@end
