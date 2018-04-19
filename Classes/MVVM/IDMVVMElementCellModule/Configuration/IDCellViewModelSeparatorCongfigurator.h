//
//  IDCellViewModelSeparatorCongfigurator.h
//  Example
//
//  Created by Андрей on 19.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@interface IDCellViewModelSeparatorCongfigurator : NSObject

+ (instancetype)default;
+ (instancetype)defaultWithInset;
+ (instancetype)configuratorWithColor: (UIColor *)color
                            leftInset: (CGFloat)leftInset
                           rightInset: (CGFloat)rightInset;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat leftInset;
@property (assign, nonatomic) CGFloat rightInset;

@end
