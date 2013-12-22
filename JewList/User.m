//
//  User.m
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark == SERIALIZATION ==
/* Deserialize */
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
	return self;
    
}

/* Serialize */
- (void)encodeWithCoder:(NSCoder*)encoder
{
    [super encodeWithCoder:encoder];
    
}

- (NSString *)fbImageUrlForSize:(CGSize)size
{
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", self.fbId,(int)size.width*scale,(int)size.height*scale];
    return url;
    
}

@end
