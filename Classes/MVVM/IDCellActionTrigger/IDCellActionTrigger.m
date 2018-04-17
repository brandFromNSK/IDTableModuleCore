//
//  IDCellActionTrigger.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 16.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <UIKit/NSIndexPath+UIKitAdditions.h>
#import "IDCellActionTrigger.h"

@interface IDCellActionTrigger ()

@property (strong, nonatomic) NSMutableSet <NSIndexPath *> *updateIndexPaths;
@property (strong, nonatomic) NSMutableSet <NSIndexPath *> *deleteIndexPaths;
@property (strong, nonatomic) NSMutableSet <NSIndexPath *> *insertIndexPaths;

@end

@implementation IDCellActionTrigger

+ (instancetype)trigger {
    return [[[self class] alloc] init];
}

- (instancetype)withAction: (IDCellAction)action atRow: (NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    switch (action) {
        case IDCellActionUpdate: {
            [self.updateIndexPaths addObject:indexPath];
        }
            break;
            
        case IDCellActionInsert: {
            [self.insertIndexPaths addObject:indexPath];
        }
            break;
            
        case IDCellActionDelete: {
            [self.deleteIndexPaths addObject:indexPath];    
        }
            break;
    }
    return self;
}

- (NSArray <NSIndexPath *> *)indexPathsWithAction: (IDCellAction)action {
    
    switch (action) {
        case IDCellActionUpdate: {
            return [self.updateIndexPaths allObjects];
        }
            
        case IDCellActionInsert: {
            return [self.insertIndexPaths allObjects];
        }
            
        case IDCellActionDelete: {
            return [self.deleteIndexPaths allObjects];
        }
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _updateIndexPaths = [NSMutableSet set];
        _deleteIndexPaths = [NSMutableSet set];
        _insertIndexPaths = [NSMutableSet set];
    }
    return self;
}


@end
