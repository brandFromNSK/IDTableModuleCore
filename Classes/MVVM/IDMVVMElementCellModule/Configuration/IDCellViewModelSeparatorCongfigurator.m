//
//  IDCellViewModelSeparatorCongfigurator.m
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDCellViewModelSeparatorCongfigurator.h"

@implementation IDCellViewModelSeparatorCongfigurator

+ (instancetype)default {
    return [self configuratorWithColor:[UIColor lightGrayColor] leftInset:0.f rightInset:0.f];
}

+ (instancetype)defaultWithInset {
    return [self configuratorWithColor:[UIColor lightGrayColor] leftInset:16.f rightInset:0.f];
}

+ (instancetype)configuratorWithColor: (UIColor *)color
                            leftInset: (CGFloat)leftInset
                           rightInset: (CGFloat)rightInset {
    
    IDCellViewModelSeparatorCongfigurator *configurator = [IDCellViewModelSeparatorCongfigurator new];
    configurator.color = color;
    configurator.leftInset = leftInset;
    configurator.rightInset = rightInset;
    return configurator;
}

@end
