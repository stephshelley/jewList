/*
 *  File    : STBaseDataModel.m
 *  Project Schmooz
 *
 *  Description : The Base Data Model is a basic implementation of a class to hanle network requests for table-view based controllers with reload capabilities
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 BBYO. All rights reserved.
 *
 */
#import "NSObjectAdditions.h"
#import "STBaseDataModel.h"


@implementation STBaseDataModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)delegates {
    if (nil == _delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoadingMore {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isOutdated {
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(STURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)load:(STURLRequestCachePolicy)cachePolicy less:(BOOL)less
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didStartLoad {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidStartLoad:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadingMore {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidFinishLoadingMore:) withObject:self];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidFinishLoad:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadWithError:(NSError*)error {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidFinishLoad:withError:) withObject:self withObject:error];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didCancelLoad {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidCancelLoad:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginUpdates {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidBeginUpdates:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endUpdates {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidEndUpdates:) withObject:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [self performSelectorForArray:_delegates withSelector:@selector(model:didUpdateObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [self performSelectorForArray:_delegates withSelector:@selector(model:didInsertObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [self performSelectorForArray:_delegates withSelector:@selector(model:didDeleteObject:atIndexPath:) withObject:self withObject:object withObject:indexPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didChange {
    [self performSelectorForArray:_delegates withSelector:@selector(modelDidChange:) withObject:self];
}

- (void)performSelectorForArray:(NSArray*)array withSelector:(SEL)selector withObject:(id)p1
{
    NSEnumerator* e = [array objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1];
        }
    }
}

- (void)performSelectorForArray:(NSArray*)array withSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2
{
    NSEnumerator* e = [array objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1 withObject:p2];
        }
    }
}

- (void)performSelectorForArray:(NSArray*)array withSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
{
    NSEnumerator* e = [array objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
        }
    }

}
@end
