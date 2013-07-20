/*
 *  File    : NSString+CamelCase.h
 *  Project : Storm Frontend
 *
 *  Description : Extenstion of NSString class to help turn json response object keys to camel case 
                in order to conform to the naming convention for our basic objects
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/23/12.
 *  Copyright 2010-2012 MilestoneLab. All rights reserved.
 *
 */

@interface NSString (CamelCase)

- (NSString *)stringAsCamelCase;
- (NSString *)stringAsUnderscores;
- (NSString *)stringAsCapitalized;

@end
