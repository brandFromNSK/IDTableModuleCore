//
//  IDTestViewController.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "IDTestViewController.h"
#import "IDTestViewModel.h"
#import "IDTestContractor.h"

@implementation IDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //!!!: Recommended to inject that with DI
    IDTestViewModel *viewModel = [IDTestViewModel new];
    viewModel.factory = [IDTestElementsModuleFactory new];
    viewModel.factory.viewModel = viewModel;
    viewModel.person = [IDPerson new];
    
    IDTestContractor *contractor = [IDTestContractor new];
    contractor.viewModel = viewModel;
    
    self.contractor = contractor;
    self.viewModel = viewModel;
    
    [self.contractor setTableView:self.tableView];
    [self.viewModel viewLoaded];
}

@end
