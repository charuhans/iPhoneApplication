//
//  SectionInfo.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SectionHeaderView;
@class HotSpot;

@interface SectionInfo : NSObject

@property (assign) BOOL open;
//
@property (retain) SectionHeaderView* headerView;

@property (nonatomic,retain,readonly) NSMutableArray *rowHeights;

@property (retain) HotSpot *hotspot;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;


@end
