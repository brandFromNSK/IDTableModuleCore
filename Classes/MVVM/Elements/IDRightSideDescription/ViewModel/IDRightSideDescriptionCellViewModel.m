//
//  IDRightSideDescriptionCellViewModel.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 21.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDRightSideDescriptionCellViewModel.h"

@implementation IDRightSideDescriptionCellViewModel

+ (instancetype)viewModelWithLeftText: (NSString *)leftText
                            rightText: (NSString *)rightText {
    
    IDRightSideDescriptionCellViewModel *viewModel = [IDRightSideDescriptionCellViewModel new];
    viewModel.leftText = leftText;
    viewModel.rightText = rightText;
    return viewModel;
}

- (NSString *)cellIdentifier {
    return @"IDRightSideDescriptionCell";
}

@end
