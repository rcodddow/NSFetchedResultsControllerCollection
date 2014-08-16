//
//  NSFetchedResultsControllerCollection.m
//  ISM Catalog
//
//  Created by Robert Codd-Downey on 2013-07-24.
//  Copyright (c) 2013 Robert Codd-Downey. All rights reserved.
//

#import "NSFetchedResultsControllerCollection.h"

@interface NSFetchedResultsControllerCollection ()

@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, strong) NSArray *sections;

@end

@implementation NSFetchedResultsControllerCollection

- (id)initWithFetchedResultsControllers:(NSArray*)controllers
{
    self = [super init];
    if (self) {
        self.controllers = controllers;
        self.sections = [NSArray new];
        self.startingSection = 0;
    }
    return self;
}

- (BOOL)performFetch:(NSError **)error
{
    NSError *err = nil;
    
    _sections = [NSArray new];
    
    for (NSFetchedResultsController *fetchResultsController in _controllers) {
        if (![fetchResultsController performFetch:&err]) {
            if (error != nil)
                *error = err;
            return NO;
        }
        self.sections = [_sections arrayByAddingObjectsFromArray:[fetchResultsController sections]];
        fetchResultsController.delegate = self;
    }
    return YES;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = self.startingSection;
    
    if (indexPath.section >= self.startingSection) {
    
        for (NSFetchedResultsController *fetchResultsController in _controllers) {
            
            NSUInteger count = [[fetchResultsController sections] count];
            
            if (indexPath.section < section + count) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - section];
                
//                id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchResultsController sections] objectAtIndex:indexPath.section];
                
  //              if (newIndexPath.row < [sectionInfo numberOfObjects]) {
                    return [fetchResultsController objectAtIndexPath:newIndexPath];
    //            } else {
        //            return nil;
      //          }
            }
            
            section += count;
        }
        
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    NSUInteger section = self.startingSection;
    
    for (NSFetchedResultsController *fetchResultsController in _controllers) {
        
        NSUInteger count = [[fetchResultsController sections] count];
        
        NSIndexPath *indexPath = [fetchResultsController indexPathForObject:object];
        if (indexPath != nil) {
            return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + section];
        }
        
        section += count;
    }
    
    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (_delegate != nil) {
        [_delegate controllerWillChangeContent:controller];
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (_delegate != nil) {
        NSUInteger section = self.startingSection;
        
        for (NSFetchedResultsController *fetchResultsController in _controllers) {
            NSUInteger count = [[fetchResultsController sections] count];
            
            if ([fetchResultsController isEqual:controller]) {
                
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + section];
                
                NSIndexPath *tmpNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section + section];
                
                [_delegate controller:controller didChangeObject:anObject atIndexPath:tmpIndexPath forChangeType:type newIndexPath:tmpNewIndexPath];
                
                break;
            }
            
            section += count;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (_delegate != nil) {
        NSUInteger section = self.startingSection;
        
        for (NSFetchedResultsController *fetchResultsController in _controllers) {
            NSUInteger count = [[fetchResultsController sections] count];
            
            if ([fetchResultsController isEqual:controller]) {
                
                NSUInteger tmpSectionIndex = sectionIndex + section;
                
                [_delegate controller:controller didChangeSection:sectionInfo atIndex:tmpSectionIndex forChangeType:type];
            }
            
            section += count;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (_delegate != nil) {
        [_delegate controllerDidChangeContent:controller];
    }
}

@end
