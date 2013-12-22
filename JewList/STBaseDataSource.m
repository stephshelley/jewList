/*
 *  File    : STBaseDataSource.m
 *  Project : Storm Frontend
 *
 *  Description : The base data source represent a simple data source model to hold json request results and
 pass it back to the calling controller
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 MilestoneLab. All rights reserved.
 *
 */


#import "STBaseDataSource.h"

@implementation STBaseDataSource

- (id)initWithDelegate:(id<STBaseDataSource>)delegate;
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
    }
    
    return self;
}

- (id)initWithItems:(NSArray*)items {
	self = [self init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
    }
    
    return self;
}
- (void)loadModel
{
    // TO BE IMPLEMENTED IN INHERITOR
}

- (void)reloadModel
{
    // TO BE IMPLEMENTED IN INHERITOR
}

#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (STBaseDataSource*)dataSourceWithObjects:(id)object,... {
    NSMutableArray* items = [NSMutableArray array];
    va_list ap;
    va_start(ap, object);
    while (object) {
        [items addObject:object];
        object = va_arg(ap, id);
    }
    va_end(ap);
    
    return [[self alloc] initWithItems:items];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (STBaseDataSource*)dataSourceWithItems:(NSMutableArray*)items {
    return [[self alloc] initWithItems:items];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}


@end
