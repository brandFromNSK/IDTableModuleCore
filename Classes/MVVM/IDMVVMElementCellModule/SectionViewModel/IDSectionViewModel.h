//
// Created by Stepan Chepurin on 8/31/17.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDSectionCellViewModelProtocol.h"
@protocol IDCellViewModelProtocol;

@interface IDSectionViewModel : NSObject <IDSectionCellViewModelProtocol>

- (NSArray *)uniqueIdentifiers;

@end
