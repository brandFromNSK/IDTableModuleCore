//
//  IDEmptyCell.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 22.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDEmptyCell.h"
#import "IDEmptyCellViewModel.h"

@interface IDEmptyCell ()

@property (strong, nonatomic) IDEmptyCellViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation IDEmptyCell

#pragma mark - IDTableViewCell override
- (void)installViewModel:(IDEmptyCellViewModel *)viewModel {
    [super installViewModel:viewModel];

    self.heightConstraint.constant = viewModel.height;
}

- (Class)viewModelClass {
    return [IDEmptyCellViewModel class];
}

@end
