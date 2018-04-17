//
//  IDTestElementsModuleFactory.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDCellViewModelProtocol;
@class IDTestViewModel;

@interface IDTestElementsModuleFactory : NSObject

@property (weak, nonatomic) IDTestViewModel *viewModel;

- (NSArray<id<IDCellViewModelProtocol>> *)elementViewModels;

@end
