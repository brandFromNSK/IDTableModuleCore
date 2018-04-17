//
//  IDRightSideDescriptionCell.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 21.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDRightSideDescriptionCell.h"
#import "IDRightSideDescriptionCellViewModel.h"

@interface IDRightSideDescriptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IDRightSideDescriptionCellViewModel *viewModel;

@end

@implementation IDRightSideDescriptionCell

#pragma mark - IDTableViewCell override
- (void)installViewModel:(IDRightSideDescriptionCellViewModel *)viewModel {
    [super installViewModel:viewModel];
    
    self.leftLabel.text = viewModel.leftText;
    self.rightLabel.text = viewModel.rightText;
    
    [self bindViewModelValues];
}

- (Class)viewModelClass {
    return [IDRightSideDescriptionCellViewModel class];
}

#pragma mark - Bindings
- (void)bindViewModelValues {
    
}

@end
