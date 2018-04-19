//
//  IDCellViewModelConfigurationProtocol.h
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCellViewModelSeparatorCongfigurator.h"

@protocol IDCellViewModelConfigurationProtocol <NSObject>

@property (strong, nonatomic) IDCellViewModelSeparatorCongfigurator *topSeparatorConfig;
@property (strong, nonatomic) IDCellViewModelSeparatorCongfigurator *bottomSeparatorConfig;

@end
