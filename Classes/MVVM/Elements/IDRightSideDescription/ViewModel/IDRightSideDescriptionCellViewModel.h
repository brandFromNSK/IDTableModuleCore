//
//  IDRightSideDescriptionCellViewModel.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 21.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDCellViewModel.h"

@interface IDRightSideDescriptionCellViewModel : IDCellViewModel

+ (instancetype)viewModelWithLeftText: (NSString *)leftText
                            rightText: (NSString *)rightText;

@property (strong, nonatomic) NSString *leftText;
@property (strong, nonatomic) NSString *rightText;

@end
