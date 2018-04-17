//
// Created by Vladimir Prigarin on 03/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDCellViewModelProtocol;

@interface IDTableViewCell : UITableViewCell

- (Class)viewModelClass;
- (void)installViewModel:(id<IDCellViewModelProtocol>)viewModel;


@end
