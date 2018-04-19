//
//  IDMutableSectionCellViewModelProtocol.h
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDCellViewModelProtocol.h"

@protocol IDMutableSectionCellViewModelProtocol <NSObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray <id<IDCellViewModelProtocol>> *cellViewModels;

@end
