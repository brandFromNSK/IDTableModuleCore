//
//  IDEmptyCellViewModel.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 22.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDEmptyCellViewModel.h"

@implementation IDEmptyCellViewModel

+ (instancetype)viewModelWithHeight: (CGFloat)height {
    
    IDEmptyCellViewModel *viewModel = [IDEmptyCellViewModel new];
    viewModel.height = height;
    return viewModel;
}

- (NSString *)cellIdentifier {
    return @"IDEmptyCell";
}

@end
