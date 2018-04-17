//
//  IDEmptyCellViewModel.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 22.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <CoreGraphics/CGBase.h>
#import "IDCellViewModel.h"

@interface IDEmptyCellViewModel : IDCellViewModel

+ (instancetype)viewModelWithHeight: (CGFloat)height;

@property (assign, nonatomic) CGFloat height;

@end
