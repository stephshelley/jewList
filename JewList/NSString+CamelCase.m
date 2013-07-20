/*
 *  File    : NSString+CamelCase.m
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

#import "NSString+CamelCase.h"

@implementation NSString (CamelCase)

- (NSString *)stringAsUnderscores {
	// TODO check if NSCharacterSet uppercaseLetterCharacterSet
	
//	if ([self rangeOfString:@"_"].location == NSNotFound) {
//		return [self mutableCopy];
//	}
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0, len = [self length]; idx < len; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (NSString *)stringAsCamelCase {
	if ([self rangeOfString:@"_"].location == NSNotFound) {
		return [self mutableCopy];
	}

	NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0, len = [self length]; idx < len; idx += 1) {
        unichar c = [self characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (NSString *)stringAsCapitalized {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

@end
