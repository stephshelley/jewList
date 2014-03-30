//
//  SHTextCellItem.h
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCellTextFontSize 16

@interface SHTextCellItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;

- (CGFloat)getCellHeight;

@end
