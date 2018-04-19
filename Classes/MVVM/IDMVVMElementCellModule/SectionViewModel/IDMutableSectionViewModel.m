//
//  IDMutableSectionViewModel.m
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDMutableSectionViewModel.h"

@implementation IDMutableSectionViewModel

@synthesize title = _title;
@synthesize cellViewModels = _cellViewModels;

- (instancetype)init {
    self = [super init];
    
    self.cellViewModels = @[].mutableCopy;
    
    return self;
}

- (NSArray *)uniqueIdentifiers {
    
    NSMutableSet *identifiersSet = [NSMutableSet set];
    
    for( id<IDCellViewModelProtocol> viewModel in self.cellViewModels ) {
        
        [identifiersSet addObject:viewModel.cellIdentifier];
    }
    
    NSArray *result = [identifiersSet allObjects];
    return result;
}

@end
