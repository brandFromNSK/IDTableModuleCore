//
// Created by Vladimir Prigarin on 02/08/2017.
// Copyright (c) 2017 Improve Digital. All rights reserved.
//


#import "IDCellViewModel.h"

@implementation IDCellViewModel

- (instancetype)init {

    self = [super init];

    return self;
}

- (NSString *)cellIdentifier {

    NSAssert(NO, @"You must override this method in child");
    return nil;
}

@end