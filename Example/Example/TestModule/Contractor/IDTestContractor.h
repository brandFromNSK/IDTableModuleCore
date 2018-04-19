//
//  IDTestContractor.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDTableModuleCoreMVVM.h"
@class IDTestViewModel;

@interface IDTestContractor : IDMVVMTableContractor <IDMVVMTableContractorProtocol>

@property (nonatomic, weak) IDTestViewModel *viewModel;

@end
