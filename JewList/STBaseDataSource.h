/*
 *  File    : STBaseDataSource.h
 *  Project Schmooz
 *
 *  Description : The base data source represent a simple data source model to hold json request results and
                  pass it back to the calling controller
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 BBYO. All rights reserved.
 *
 */


#import "STBaseDataModel.h"

@protocol STBaseDataSource <NSObject>

@optional;
- (void)dataSourceLoaded:(id)dataSource;
- (void)dataSourceError:(NSError *)error;

@end

@interface STBaseDataSource : NSObject


@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) id<STBaseDataSource> delegate;

/* init */
+ (STBaseDataSource*)dataSourceWithObjects:(id)object,...;
+ (STBaseDataSource*)dataSourceWithItems:(NSMutableArray*)items;

- (id)initWithItems:(NSArray*)items;
- (id)initWithDelegate:(id<STBaseDataSource>)delegate;
- (void)loadModel;
- (void)reloadModel;

@end
