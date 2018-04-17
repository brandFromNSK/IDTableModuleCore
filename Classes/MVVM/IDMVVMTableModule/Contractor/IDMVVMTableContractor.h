//
// Created by Vladimir Prigarin on 04/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDMVVMTableContractorProtocol.h"
@protocol IDCellViewModelProtocol;
@protocol IDSectionCellViewModelProtocol;
@class IDTableViewCell;
@class RACTuple;
@class IDCellActionTrigger;


@interface IDMVVMTableContractor : NSObject  <IDMVVMTableContractorProtocol>

@property (nonatomic, weak) UITableView *tableView;

- (void)makeTableViewConstraintsEqualToContentSize;

- (void)reloadTableView: (NSNumber *)needReload;
- (void)updateTableView: (NSNumber *)needUpdate;
- (void)updateTableViewWithTuple: (RACTuple *)tuple;
- (void)updateTableViewWithTuples: (NSArray<RACTuple *> *)tuples;
- (void)updateTableViewWithCellViewModels: (NSArray<id<IDCellViewModelProtocol>> *)viewModels;
- (void)updateTableViewWithSections: (NSArray<id<IDSectionCellViewModelProtocol>> *)sections;

- (void)updateTableViewWithTrigger: (IDCellActionTrigger *)trigger;

- (void)registerReusableCellWithCellViewModels:(NSArray<id<IDCellViewModelProtocol>> *)cellViewModels;
- (__kindof IDTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
                         withIdentifier:(NSString *)cellIdentifier
                              viewModel:(id <IDCellViewModelProtocol> )viewModel;

@end
