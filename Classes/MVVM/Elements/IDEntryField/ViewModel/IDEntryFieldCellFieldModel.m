//
//  IDEntryFieldCellFieldModel.m
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 29.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import <CoreGraphics/CGBase.h>
#import "NSString+Additions.h"
#import "IDEntryFieldCellFieldModel.h"

@interface IDEntryFieldCellFieldModel ()

@property (strong, nonatomic, readwrite) NSString *keyPath;
@property (assign, nonatomic, readwrite) BOOL isCustomizedProportion;

@property (assign, nonatomic, readwrite) BOOL isFirstResponderForceCalled;

// Currency mode
@property (assign, nonatomic, readwrite) BOOL currencyMode;
@property (strong, nonatomic, readwrite) NSLocale *locale;

@end

@implementation IDEntryFieldCellFieldModel

+ (instancetype)fieldModelWithRawValue: (id)rawValue boundKeyPath: (NSString *)keyPath {

    if (self == [IDEntryFieldCellFieldModel class]) {
        IDEntryFieldCellFieldModel *fieldModel = [[IDEntryFieldCellFieldModel alloc] init];
        fieldModel.keyPath = keyPath;
        fieldModel.rawValue = rawValue;
        return fieldModel;
    }
    return nil;
}

+ (instancetype)fieldModelWithRawValue: (id <NSObject>)rawValue {
    return [self fieldModelWithRawValue:rawValue boundKeyPath:nil];
}

- (instancetype)init {

    self = [super init];

    [self initializeDefaultProperties];
    return self;
}

- (void)initializeDefaultProperties {

    _editable = YES;
    _showFloatingLabel = YES;
    _showSeparator = YES;
}

- (void)setProportion:(CGFloat)proportion {
    _proportion = proportion;
    _isCustomizedProportion = YES;
}

- (void)setupCurrencyModeWithLocale: (NSLocale *)locale {
    _currencyMode = YES;
    _locale = locale;
}

- (void)makeAsFirstResponder {
    self.isFirstResponderForceCalled = YES;
}

- (NSString *)value {
    
    if (self.pattern != nil) {
        return [self.rawValue id_stringWithPattern:self.pattern];
    }
    return self.rawValue;
}

@end
