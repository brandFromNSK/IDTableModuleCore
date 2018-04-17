//
//  IDTestViewController.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 17/04/2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <UIKit/UITableView.h>

@class IDTestViewModel;
@class IDTestContractor;

@interface IDTestViewController : UIViewController

@property (nonatomic, strong) IDTestViewModel *viewModel;
@property (nonatomic, strong) IDTestContractor *contractor;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
