//
//  IDTestElementsModuleFactory.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//


#import "IDTestElementsModuleFactory.h"
#import "IDTestViewModel.h"

#import <ReactiveObjC/ReactiveObjC.h>

// Cell view models
#import "IDEntryFieldCellViewModel.h"


@implementation IDTestElementsModuleFactory

- (NSArray<id<IDCellViewModelProtocol>> *)elementViewModels {

    return @[[self lastNameViewModel],
             [self firstNameViewModel],
             [self patronymicViewModel]];
}

#pragma mark - Cells
- (id <IDCellViewModelProtocol>)lastNameViewModel {
    
    NSString *value = self.viewModel.person.lastName;
    NSString *keyPath = @keypath(self.viewModel.person, lastName);
    
    IDEntryFieldCellFieldModel *fieldModel = [IDEntryFieldCellFieldModel fieldModelWithRawValue:value
                                                                                   boundKeyPath:keyPath];
    fieldModel.placeholder = @"Фамилия";
    
    IDEntryFieldCellViewModel *viewModel = [IDEntryFieldCellViewModel viewModelWithFieldModel:fieldModel];
    return viewModel;
}

- (id <IDCellViewModelProtocol>)firstNameViewModel {
    
    NSString *value = self.viewModel.person.firstName;
    NSString *keyPath = @keypath(self.viewModel.person, firstName);
    
    IDEntryFieldCellFieldModel *fieldModel = [IDEntryFieldCellFieldModel fieldModelWithRawValue:value
                                                                                   boundKeyPath:keyPath];
    fieldModel.placeholder = @"Имя";
    
    IDEntryFieldCellViewModel *viewModel = [IDEntryFieldCellViewModel viewModelWithFieldModel:fieldModel];
    return viewModel;
}

- (id <IDCellViewModelProtocol>)patronymicViewModel {
    
    NSString *value = self.viewModel.person.patronymic;
    NSString *keyPath = @keypath(self.viewModel.person, patronymic);
    
    IDEntryFieldCellFieldModel *fieldModel = [IDEntryFieldCellFieldModel fieldModelWithRawValue:value
                                                                                   boundKeyPath:keyPath];
    fieldModel.placeholder = @"Отчество";
    
    IDEntryFieldCellViewModel *viewModel = [IDEntryFieldCellViewModel viewModelWithFieldModel:fieldModel];
    return viewModel;
}

@end
