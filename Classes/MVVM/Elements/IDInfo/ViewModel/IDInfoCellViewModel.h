//
//  IDInfoCellViewModel.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDCellViewModel.h"

typedef NS_ENUM(NSUInteger, IDInfoPosition) {
    IDInfoPositionLeft,
    IDInfoPositionCenter,
    IDInfoPositionRight
};

@interface IDInfoCellViewModel : IDCellViewModel

+ (instancetype)viewModelWithTitle: (NSString *)title
                       description: (NSString *)description;

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *descriptionText;
@property (assign, nonatomic) IDInfoPosition textPosition;

@end
