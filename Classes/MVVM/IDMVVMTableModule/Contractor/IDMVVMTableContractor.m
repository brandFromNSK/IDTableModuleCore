//
// Created by Vladimir Prigarin on 04/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//

#import <objc/runtime.h>
#import "IDMVVMTableContractor.h"

#import "IDTableViewCell.h"

#import "IDSectionCellViewModelProtocol.h"

#import "IDCellActionTrigger.h"

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

static const CGFloat kUITableViewDefaultRowHeight = 44.0f;


@interface IDMVVMTableContractor ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *rowHeightsDictionary;

@end

@implementation IDMVVMTableContractor

- (instancetype)init {

    self = [super init];

    _rowHeightsDictionary = [NSMutableDictionary dictionary];

    return self;
}

- (void)setTableView:(UITableView *)tableView {

    _tableView = tableView;
    
    // Table view frame is not actual until force layout updates!
    [_tableView setNeedsLayout];
    [_tableView layoutIfNeeded];

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = UITableViewAutomaticDimension;

    [self bindCellViewModels];
    [self bindUpdates];
}

- (void)bindCellViewModels {

    NSAssert(NO, @"You must override this in child");
}

- (void)bindUpdates {
    
    NSLog(@"bindUpdates is not overridden");
}

- (void)registerReusableCellWithCellViewModels:(NSArray<id<IDCellViewModelProtocol>> *)cellViewModels {

    if( nil == cellViewModels ) {
        return;
    }

    NSAssert(nil != self.tableView, @"Value of 'self.tableView' should never be nil");

    NSArray<NSString *> *identifiers = [self uniqueIdentifiersFromViewModels:cellViewModels];

    for( NSString *reusableIdentifier in identifiers ) {

        NSArray *reusedStringArray = [reusableIdentifier componentsSeparatedByString:@"**"];
        Class cellClass = objc_getClass([reusedStringArray.firstObject cStringUsingEncoding:NSUTF8StringEncoding]);
        NSAssert(Nil != cellClass, @"Class for cell '%@' should be named exactly as ReusableID", reusableIdentifier);
        
        if ([[NSBundle mainBundle] pathForResource:reusableIdentifier ofType:@"nib"] != nil) {
            UINib *cellNib = [UINib nibWithNibName:reusableIdentifier bundle:nil];
            
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:reusableIdentifier
                                                              owner:self
                                                            options:nil];
            
            if (nibViews.firstObject) {
                [self.tableView registerNib:cellNib forCellReuseIdentifier:reusableIdentifier];
            }
        }
        else {
            [self.tableView registerClass:cellClass forCellReuseIdentifier:reusableIdentifier];
        }
    }
}

- (NSArray *)uniqueIdentifiersFromViewModels:(NSArray<id<IDCellViewModelProtocol>> *)cellViewModels {

    NSMutableSet *identifiersSet = [NSMutableSet set];

    for( id<IDCellViewModelProtocol> viewModel in cellViewModels ) {
        [identifiersSet addObject:viewModel.cellIdentifier];
    }

    NSArray *result = [identifiersSet allObjects];
    return result;
}

#pragma mark - TableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSAssert(NO, @"You must override this method in child");
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (__kindof IDTableViewCell *)tableView:(UITableView *)tableView
                  cellForRowAtIndexPath:(NSIndexPath *)indexPath
                         withIdentifier:(NSString *)cellIdentifier
                              viewModel:(id<IDCellViewModelProtocol>)viewModel {
    
    IDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [cell installViewModel:viewModel];
    
    const CGSize size = [cell.contentView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.rowHeightsDictionary[ indexPath ] = @(size.height);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = kUITableViewDefaultRowHeight;

    NSNumber *calculatedHeight = self.rowHeightsDictionary[ indexPath ];

    if( nil != calculatedHeight ) {
        height = calculatedHeight.floatValue;
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - TableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Interface
- (void)makeTableViewConstraintsEqualToContentSize {
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tableView.contentSize.height);
    }];
}

- (void)reloadTableView: (NSNumber *)needReload {
    
    if (needReload.boolValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)updateTableView: (NSNumber *)needUpdate {
    
    if (needUpdate.boolValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:NO];
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            [UIView setAnimationsEnabled:YES];
        });
    }
}

- (void)updateTableViewWithCellViewModels: (NSArray<id<IDCellViewModelProtocol>> *)viewModels {
    
    [self registerReusableCellWithCellViewModels:viewModels];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    });
}

- (void)updateTableViewWithSections: (NSArray<id<IDSectionCellViewModelProtocol>> *)sections {
    
    for (id<IDSectionCellViewModelProtocol> section in sections) {
        [self registerReusableCellWithCellViewModels:section.cellViewModels];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    });
}

- (void)updateTableViewWithTrigger: (IDCellActionTrigger *)trigger {
    
    if (trigger == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:[trigger indexPathsWithAction:IDCellActionInsert] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[trigger indexPathsWithAction:IDCellActionDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadRowsAtIndexPaths:[trigger indexPathsWithAction:IDCellActionUpdate] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    });
}

@end
