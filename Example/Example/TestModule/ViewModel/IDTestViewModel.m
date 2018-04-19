//
//  IDTestViewModel.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "IDTestViewModel.h"

@implementation IDTestViewModel

- (void)viewLoaded {
    [self updateCellViewModels];
}

- (void)updateCellViewModels {
    self.cellViewModels = [self.factory elementViewModels];
}

#pragma mark - IDEntryFieldCellViewModelDelegate
- (void)viewModel:(IDEntryFieldCellViewModel *)viewModel
   didChangeValue:(NSString *)value
         rawValue:(NSString *)rawValue
      withKeyPath:(NSString *)keyPath {
    
    [self setValue:rawValue forKeyPath:keyPath];
}

@end
