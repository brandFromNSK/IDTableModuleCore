//
//  IDTestViewModel.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDTestElementsModuleFactory.h"
#import "IDPerson.h"

@protocol IDCellViewModelProtocol;

@interface IDTestViewModel : NSObject

@property (nonatomic, strong) NSArray<id<IDCellViewModelProtocol>> *cellViewModels;
@property (nonatomic, strong) IDTestElementsModuleFactory *factory;
@property (nonatomic, strong) IDPerson *person;

- (void)viewLoaded;

@end
