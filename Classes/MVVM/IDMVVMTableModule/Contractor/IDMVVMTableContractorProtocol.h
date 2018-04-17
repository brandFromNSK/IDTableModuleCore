//
// Created by Vladimir Prigarin on 04/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import <UIKit/UITableView.h>

@protocol IDMVVMTableContractorProtocol <UITableViewDelegate, UITableViewDataSource>

- (void)bindCellViewModels;
- (void)bindUpdates;

@end
