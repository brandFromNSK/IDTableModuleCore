//
//  IDInfoCellViewModel.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDInfoCellViewModel.h"

@interface IDInfoCellViewModel ()

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *descriptionText;

@end

@implementation IDInfoCellViewModel

+ (instancetype)viewModelWithTitle: (NSString *)title description: (NSString *)description {
    
    IDInfoCellViewModel *viewModel = [IDInfoCellViewModel new];
    viewModel.title = title;
    viewModel.descriptionText = description;
    viewModel.textPosition = IDInfoPositionCenter;
    return viewModel;
}

- (NSString *)cellIdentifier {
    return @"IDInfoCell";
}

@end
