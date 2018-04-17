//
// Created by Stepan Chepurin on 8/31/17.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//

#import "IDSectionViewModel.h"

@interface IDSectionViewModel ()

@end

@implementation IDSectionViewModel

@synthesize title = _title;
@synthesize cellViewModels = _cellViewModels;

- (instancetype)init {
    self = [super init];

    self.cellViewModels = @[];

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
