//
//  SHToggleButton.m
//  JewList
//
//  Created by Mihai Chiorean on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHToggleButton.h"

@interface SHToggleButton() {
    
}
@end
@implementation SHToggleButton

@synthesize isOn;
@synthesize colorOn;
@synthesize colorOff;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)toggle {
    isOn = !isOn;
    if(isOn) {
        [self setBackgroundColor:colorOn];
    } else {
        [self setBackgroundColor:colorOff];
    }
}

- (void)toggle:(BOOL)isOn {
    [self setIsOn:!isOn];
    [self toggle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
