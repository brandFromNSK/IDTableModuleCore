//
// Created by Vladimir Prigarin on 03/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDTableViewCell.h"
#import "IDCellViewModelProtocol.h"

@implementation IDTableViewCell

- (void)installViewModel:(id<IDCellViewModelProtocol>)viewModel {
    
    NSAssert([viewModel isKindOfClass:[self viewModelClass]], @"viewModel should be kind of class '%@'", NSStringFromClass([self viewModelClass]));

    if ([viewModel isKindOfClass:[self viewModelClass]]) {
        [self setValue:viewModel forKey:@"viewModel"];
    }
}

- (Class)viewModelClass {
    NSAssert(NO, @"You must override this method in child");
    
    return [NSNull class];
}

@end
