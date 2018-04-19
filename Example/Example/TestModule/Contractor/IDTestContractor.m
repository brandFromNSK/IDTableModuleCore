//
//  IDTestContractor.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//


#import "IDTestContractor.h"
#import "IDTestViewModel.h"

#import "IDTableModuleCoreMVVM.h"
#import <ReactiveObjC/ReactiveObjC.h>


@implementation IDTestContractor

#pragma mark - Bindings
- (void)bindCellViewModels {
    [self rac_liftSelector:@selector(updateTableViewWithCellViewModels:) withSignals:RACObserve(self.viewModel, cellViewModels), nil];
}

#pragma mark - TableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = (NSUInteger)indexPath.row;
    
    id<IDCellViewModelProtocol> cellViewModel = self.viewModel.cellViewModels[row];
    IDTableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath withIdentifier:cellViewModel.cellIdentifier viewModel:cellViewModel];
    
    return cell;
}


#pragma mark - TableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellViewModels.count;
}

@end
