//
//  IDInfoCell.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDInfoCell.h"
#import "IDInfoCellViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface IDInfoCell ()

@property (strong, nonatomic) IDInfoCellViewModel *viewModel;

@end

@implementation IDInfoCell


#pragma mark - IDTableViewCell override
- (void)installViewModel:(IDInfoCellViewModel *)viewModel {
    [super installViewModel:viewModel];
    
    self.titleLabel.text = viewModel.title;
    self.descriptionLabel.text = viewModel.descriptionText;
    
    [self rac_liftSelector:@selector(positionUpdated:) withSignals:RACObserve(viewModel, textPosition) , nil];
}

- (Class)viewModelClass {
    return [IDInfoCellViewModel class];
}

#pragma mark - Observed methods
- (void)positionUpdated: (NSNumber *)number {
    
    IDInfoPosition position = number.integerValue;
    switch (position) {
            
        case IDInfoPositionLeft: {
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
            
        case IDInfoPositionCenter: {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        case IDInfoPositionRight: {
            self.titleLabel.textAlignment = NSTextAlignmentRight;
            self.descriptionLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
    }
}

@end
