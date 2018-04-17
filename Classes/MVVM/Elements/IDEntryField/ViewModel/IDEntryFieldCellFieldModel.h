//
//  IDEntryFieldCellFieldModel.h
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 29.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

#import "IDEntryFieldType.h"
#import "IDEntryFieldTransformationType.h"
#import "IDEntryFieldValidation.h"

static NSString * const kIDPhonePattern = @"+7 (###) ### ##-##";
static NSString * const kIDDatePattern = @"##.##.####";

@interface IDEntryFieldCellFieldModel : NSObject

@property (strong, nonatomic) NSString *rawValue;           // real value excluding filters
@property (strong, nonatomic, readonly) NSString *value;     // current text in a entry field
@property (strong, nonatomic, readonly) NSString *keyPath;

+ (instancetype)fieldModelWithRawValue: (id <NSObject>)rawValue boundKeyPath: (NSString *)keyPath;
+ (instancetype)fieldModelWithRawValue: (id <NSObject>)rawValue;

/* default: YES */
@property (assign, nonatomic, getter=isEditable) BOOL editable;

/* default: nil */
@property (strong, nonatomic) NSString *placeholder;

/* default:
 1.0f for 1 row,
 0.5f for 2 rows etc */
@property (assign, nonatomic) CGFloat proportion;
@property (assign, nonatomic, readonly) BOOL isCustomizedProportion;

/* default: IDEntryFieldTypeTextView */
@property (assign, nonatomic) IDEntryFieldType entryFieldType;

/*
 mask symbol: #, example: +7 (###) ###-##-##
 automatically install UIKeyboardTypeASCIICapableNumberPad keyboardType
 */
@property (strong, nonatomic) NSString *pattern;

/* 0 means infinity */
@property (assign, nonatomic) NSUInteger lengthLimit;

/* default: IDEntryFieldTransformationTypeNone */
@property (assign, nonatomic) IDEntryFieldTransformationType transformation;

/* default: NO */
@property (assign, nonatomic, readonly) BOOL currencyMode;
@property (strong, nonatomic, readonly) NSLocale *locale;
- (void)setupCurrencyModeWithLocale: (NSLocale *)locale;

/* default NO */
@property (assign, nonatomic) BOOL secureTextEntry;

/* default YES */
@property (assign, nonatomic) BOOL showFloatingLabel;

/* default YES */
@property (assign, nonatomic) BOOL showSeparator;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/* return nil if not needed */
@property (strong, nonatomic) NSArray <IDEntryFieldValidation *> *validations;

/* default: NO */
@property (assign, nonatomic) BOOL numericKeyboard;

- (void)makeAsFirstResponder;
@property (assign, nonatomic, readonly) BOOL isFirstResponderForceCalled;

@end
