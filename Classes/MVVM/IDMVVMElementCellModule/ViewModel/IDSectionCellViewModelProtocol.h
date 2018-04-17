//
// Created by Vladimir Prigarin on 22/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDCellViewModelProtocol.h"

@protocol IDSectionCellViewModelProtocol <NSObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <id<IDCellViewModelProtocol>> *cellViewModels;

@end
