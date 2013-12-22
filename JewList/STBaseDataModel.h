/*
 *  File    : STBaseDataModel.h
 *  Project : Storm Frontend
 *
 *  Description : The Base Data Model is a basic implementation of a class to hanle network requests for table-view based controllers with reload capabilities 
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 MilestoneLab. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


/* Varous network cache policies enum */
typedef enum {
    STURLRequestCachePolicyReloading = 999,
    STURLRequestCachePolicyNone    = 0,
    STURLRequestCachePolicyMemory  = 1,
    STURLRequestCachePolicyDisk    = 2,
    STURLRequestCachePolicyNetwork = 4,
    STURLRequestCachePolicyNoCache = 8,
    STURLRequestCachePolicyEtag    = 16 | STURLRequestCachePolicyDisk,
    STURLRequestCachePolicyLocal
    = (STURLRequestCachePolicyMemory | STURLRequestCachePolicyDisk),
    STURLRequestCachePolicyDefault
    = (STURLRequestCachePolicyMemory | STURLRequestCachePolicyDisk
       | STURLRequestCachePolicyNetwork),
} STURLRequestCachePolicy;


@protocol STBaseDataModel <NSObject>

/**
 * An array of objects that conform to the TTModelDelegate protocol.
 */
- (NSMutableArray*)delegates;

/**
 * Indicates that the data has been loaded.
 *
 * Default implementation returns YES.
 */
- (BOOL)isLoaded;

/**
 * Indicates that the data is in the process of loading.
 *
 * Default implementation returns NO.
 */
- (BOOL)isLoading;

/**
 * Indicates that the data is in the process of loading additional data.
 *
 * Default implementation returns NO.
 */
- (BOOL)isLoadingMore;

/**
 * Loads the model.
 *
 * Default implementation does nothing.
 */
- (void)load:(STURLRequestCachePolicy)cachePolicy more:(BOOL)more;

/**
 * Cancels a load that is in progress.
 *
 * Default implementation does nothing.
 */
- (void)cancel;

- (void)load:(STURLRequestCachePolicy)cachePolicy less:(BOOL)less;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A default implementation of STBaseDataModel does nothing other than appear to be loaded.
 */

@interface STBaseDataModel : NSObject <STBaseDataModel>


@property (nonatomic, strong) NSMutableArray *delegates;

/**
 * Notifies delegates that the model started to load.
 */
- (void)didStartLoad;

/**
 * Notifies delegates that the model finished loading
 */
- (void)didFinishLoad;

/**
 * Notifies delegates that the model failed to load.
 */
- (void)didFailLoadWithError:(NSError*)error;

/**
 * Notifies delegates that the model canceled its load.
 */
- (void)didCancelLoad;

/**
 * Notifies delegates that the model has begun making multiple updates.
 */
- (void)beginUpdates;

/**
 * Notifies delegates that the model has completed its updates.
 */
- (void)endUpdates;

/**
 * Notifies delegates that an object was updated.
 */
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 * Notifies delegates that an object was inserted.
 */
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 * Notifies delegates that an object was deleted.
 */
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 * Notifies delegates that the model changed in some fundamental way.
 */
- (void)didChange;


@end
