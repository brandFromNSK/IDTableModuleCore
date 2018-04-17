//
//  IDEntryFieldCellViewModel.h
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 28.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "IDCellViewModel.h"

#import "IDEntryFieldCellFieldModel.h"
#import "IDEntryFieldCellElementsPosition.h"
#import "IDEntryFieldCellState.h"

#import "IDValidatableCellViewModelProtocol.h"
#import "IDUpdatableCellViewModelProtocol.h"
@class IDEntryFieldCellViewModel;


@protocol IDEntryFieldCellViewModelDelegate <NSObject>

- (void)viewModel: (IDEntryFieldCellViewModel *)viewModel
   didChangeValue: (NSString *)value
         rawValue: (NSString *)rawValue
      withKeyPath: (NSString *)keyPath;

@end

@interface IDEntryFieldCellViewModel : IDCellViewModel <IDValidatableCellViewModelProtocol, IDUpdatableCellViewModelProtocol>

- (instancetype)init NS_DESIGNATED_INITIALIZER;

+ (instancetype)viewModelWithFieldModel: (IDEntryFieldCellFieldModel *)fieldModel;
+ (instancetype)viewModelWithFieldModels: (NSArray <IDEntryFieldCellFieldModel *> *)fieldModels;
+ (instancetype)viewModelWithValue: (NSString *)value keyPath: (NSString *)keyPath;

@property (weak, nonatomic) id <IDEntryFieldCellViewModelDelegate> delegate;
@property (strong, nonatomic, readonly) NSArray <IDEntryFieldCellFieldModel *> *fieldModels;

//* default: {0, 20, 0, 20} */
@property (assign, nonatomic) UIEdgeInsets contentInsets;

/* default: IDEntryFieldPositionTypeLeft */
@property (assign, nonatomic) IDEntryFieldCellElementsPosition position;

/* default: IDEntryFieldCellStateNormal */
@property (assign, nonatomic) IDEntryFieldCellState state;

/* default: [UIColor clearColor]] */
@property (assign, nonatomic) UIColor *backgroundColor;

/* default: NO */
@property (assign, nonatomic) BOOL manualValidation;

- (NSString *)changedStringWithPatternHandling: (NSString *)text range: (NSRange)range;
- (NSString *)filteredStringWithString: (NSString *)string pattern: (NSString *)pattern;
- (NSString *)rawStringWithFilteredString: (NSString *)string pattern: (NSString *)pattern;

// Currency
- (NSString *)currencyStringWithRawText: (NSString *)rawText locale: (NSLocale *)locale;
- (NSString *)rawCurrencyStringWithText: (NSString *)text
                                rawText: (NSString *)rawText
                            currentText: (NSString *)currentText
                                  range: (NSRange)range;

- (NSTextAlignment)textAlignmentWithPosition: (IDEntryFieldCellElementsPosition)position;
- (NSString *)updatedText: (NSString *)text withTransformationType: (IDEntryFieldTransformationType)type;
- (BOOL)singleDeleteForPatternedFieldWithText: (NSString *)text range: (NSRange)range;

- (BOOL)validateEveryEntryField;
- (BOOL)validateCellFieldModel: (IDEntryFieldCellFieldModel *)cellFieldModel;
- (void)makeAsFirstResponder;

@property (strong, nonatomic, readonly) RACSignal *valueSignal; // NSString
@property (strong, nonatomic, readonly) RACSignal *descriptionSignal; // NSString
@property (strong, nonatomic, readonly) RACSignal *stateSignal; // NSNumber

@property (assign, nonatomic) BOOL needUpdate;

@end
