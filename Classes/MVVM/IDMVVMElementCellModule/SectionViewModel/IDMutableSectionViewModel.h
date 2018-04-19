//
//  IDMutableSectionViewModel.h
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDMutableSectionCellViewModelProtocol.h"
@protocol IDCellViewModelProtocol;

@interface IDMutableSectionViewModel : NSObject <IDMutableSectionCellViewModelProtocol>

- (NSArray *)uniqueIdentifiers;

@end
