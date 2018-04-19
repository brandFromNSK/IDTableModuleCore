//
// Created by Vladimir Prigarin on 03/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDTableViewCell.h"
#import "IDCellViewModelProtocol.h"
#import "IDCellViewModelConfigurationProtocol.h"
#import <ReactiveObjC/ReactiveObjC.h>

static CGFloat kIDDefaultSeparatorWidth = 0.5f;

@interface IDTableViewCell ()

@property (strong, nonatomic) UIView *topSeparator;
@property (strong, nonatomic) NSLayoutConstraint *topSeparatorLeftInsetConstraint;
@property (strong, nonatomic) NSLayoutConstraint *topSeparatorRightInsetConstraint;

@property (strong, nonatomic) UIView *bottomSeparator;
@property (strong, nonatomic) NSLayoutConstraint *bottomSeparatorLeftInsetConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomSeparatorRightInsetConstraint;

@end

@implementation IDTableViewCell

- (void)installViewModel:(id<IDCellViewModelProtocol, IDCellViewModelConfigurationProtocol>)viewModel {
    
    NSAssert([viewModel isKindOfClass:[self viewModelClass]], @"viewModel should be kind of class '%@'", NSStringFromClass([self viewModelClass]));

    if ([viewModel isKindOfClass:[self viewModelClass]]) {
        [self setValue:viewModel forKey:@"viewModel"];
    }
    
    [self bindTopSeparatorConfigWithViewModel:viewModel];
    [self bindBottomSeparatorConfigWithViewModel:viewModel];
}

- (Class)viewModelClass {
    NSAssert(NO, @"You must override this method in child");
    
    return [NSNull class];
}

#pragma mark - Private
- (void)addTopSeparatorView {
    
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:separator];
    
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [separator.topAnchor constraintEqualToAnchor: self.contentView.topAnchor].active = YES;
    self.topSeparatorLeftInsetConstraint =  [separator.leftAnchor constraintEqualToAnchor: self.contentView.leftAnchor];
    self.topSeparatorLeftInsetConstraint.active = YES;
    
    self.topSeparatorRightInsetConstraint = [separator.rightAnchor constraintEqualToAnchor: self.contentView.rightAnchor];
    self.topSeparatorRightInsetConstraint.active = YES;
    [separator.heightAnchor constraintEqualToConstant:kIDDefaultSeparatorWidth].active = YES;
    
    self.topSeparator = separator;
}

- (void)addBottomSeparatorView {
    
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:separator];
    
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [separator.bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor].active = YES;
    self.bottomSeparatorLeftInsetConstraint =  [separator.leftAnchor constraintEqualToAnchor: self.contentView.leftAnchor];
    self.bottomSeparatorLeftInsetConstraint.active = YES;
    
    self.bottomSeparatorRightInsetConstraint = [separator.rightAnchor constraintEqualToAnchor: self.contentView.rightAnchor];
    self.bottomSeparatorRightInsetConstraint.active = YES;
    [separator.heightAnchor constraintEqualToConstant:kIDDefaultSeparatorWidth].active = YES;
    
    self.bottomSeparator = separator;
}

- (void)bindTopSeparatorConfigWithViewModel: (id <IDCellViewModelConfigurationProtocol>)viewModel {
    
    @weakify(self)
    [[RACObserve(viewModel, topSeparatorConfig) ignore:nil] subscribeNext:^(IDCellViewModelSeparatorCongfigurator *config) {
        @strongify(self)
        
        if (self.topSeparator == nil) {
            [self addTopSeparatorView];
        }
        
        self.topSeparator.backgroundColor = config.color;
        self.topSeparatorLeftInsetConstraint.constant = config.leftInset;
        self.topSeparatorRightInsetConstraint.constant = -config.rightInset;
    }];
}

- (void)bindBottomSeparatorConfigWithViewModel: (id <IDCellViewModelConfigurationProtocol>)viewModel {
    
    @weakify(self)
    [[RACObserve(viewModel, bottomSeparatorConfig) ignore:nil] subscribeNext:^(IDCellViewModelSeparatorCongfigurator *config) {
        @strongify(self)
        
        if (self.bottomSeparator == nil) {
            [self addBottomSeparatorView];
        }
        
        self.bottomSeparator.backgroundColor = config.color;
        self.bottomSeparatorLeftInsetConstraint.constant = config.leftInset;
        self.bottomSeparatorRightInsetConstraint.constant = -config.rightInset;
    }];
}

@end
