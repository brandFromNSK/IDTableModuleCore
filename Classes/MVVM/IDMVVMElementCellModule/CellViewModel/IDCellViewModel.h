//
// Created by Vladimir Prigarin on 02/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//

#import "IDCellViewModelProtocol.h"
#import "IDCellViewModelConfigurationProtocol.h"

@interface IDCellViewModel : NSObject <IDCellViewModelProtocol, IDCellViewModelConfigurationProtocol>

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end
