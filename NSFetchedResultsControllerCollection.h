//
//  NSFetchedResultsControllerCollection.h
//  ISM Catalog
//
//  Created by Robert Codd-Downey on 2013-07-24.
//  Copyright (c) 2013 Robert Codd-Downey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFetchedResultsControllerCollection : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) NSUInteger startingSection;

@property (nonatomic, readonly) NSArray *controllers;

@property (nonatomic, readonly) NSArray *sections;

@property (nonatomic, weak) id<NSFetchedResultsControllerDelegate> delegate;

- (id)initWithFetchedResultsControllers:(NSArray*)controllers;

- (BOOL)performFetch:(NSError **)error;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForObject:(id)object;

@end
