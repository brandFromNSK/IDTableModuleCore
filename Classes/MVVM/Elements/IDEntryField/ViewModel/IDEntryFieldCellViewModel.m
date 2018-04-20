//
//  IDEntryFieldCellViewModel.m
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 28.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import "IDEntryFieldCellViewModel.h"
#import "NSString+Additions.h"

@interface IDEntryFieldCellViewModel ()

@property (strong, nonatomic, readwrite) NSString *uniqueIdentifier;

@property (strong, nonatomic, readwrite) RACSignal *valueSignal;
@property (strong, nonatomic, readwrite) NSArray <IDEntryFieldCellFieldModel *> *fieldModels;
@property (strong, nonatomic) NSString *descriptionText;

@end

@implementation IDEntryFieldCellViewModel

- (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"IDEntryFieldCell**%lu**%lu**",
            (unsigned long)_fieldModels.count,
            (unsigned long)_fieldModels.firstObject.entryFieldType];
}

+ (instancetype)viewModelWithFieldModel: (IDEntryFieldCellFieldModel *)fieldModel {
    return [self viewModelWithFieldModels:@[fieldModel]];
}

+ (instancetype)viewModelWithFieldModels: (NSArray <IDEntryFieldCellFieldModel *> *)fieldModels {
    
    IDEntryFieldCellViewModel *viewModel = [[IDEntryFieldCellViewModel alloc] init];
    viewModel.fieldModels = fieldModels;
    return viewModel;
}

+ (instancetype)viewModelWithValue: (NSString *)value keyPath: (NSString *)keyPath {
    
    IDEntryFieldCellFieldModel *fieldModel = [IDEntryFieldCellFieldModel fieldModelWithRawValue:value
                                                                                   boundKeyPath:keyPath];
    IDEntryFieldCellViewModel *viewModel = [IDEntryFieldCellViewModel viewModelWithFieldModel:fieldModel];
    return viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeDefaultProperties];
    }
    return self;
}

- (void)setFieldModels:(NSArray<IDEntryFieldCellFieldModel *> *)fieldModels {
    _fieldModels = fieldModels;
    
    RACSequence *sequence = [self.fieldModels.rac_sequence map:^id _Nullable(IDEntryFieldCellFieldModel * _Nullable value) {
        return [RACObserve(value, rawValue) skip:1];
    }];
    
    self.valueSignal = [[RACSignal combineLatest:sequence] map:^id _Nullable(RACTuple * _Nullable value) {
        return value.first;
    }];
}

static CGFloat const kDefaultLeftInset = 20.0f;
static CGFloat const kDefaultRightInset = 20.0f;
- (void)initializeDefaultProperties {

    _uniqueIdentifier = [[NSUUID UUID] UUIDString];
    _backgroundColor = [UIColor clearColor];
    _contentInsets = UIEdgeInsetsMake(0, kDefaultLeftInset, 0, kDefaultRightInset);
    _manualValidation = NO;
}

#pragma mark - IDValidatableCellViewModelProtocol
- (BOOL)validate {
   return [self validateEveryEntryField];
}

- (NSString *)nonValidText {
    
    NSMutableArray *nonValidPlaceholders = [NSMutableArray new];
    for (IDEntryFieldCellFieldModel *fieldModel in self.fieldModels) {
        BOOL valid = [self validateCellFieldModel:fieldModel];
        if (!valid) {
            
            //TODO: handle others validations
            [nonValidPlaceholders addObject:fieldModel.validations.firstObject.errorMessage];
        }
    }
    return [nonValidPlaceholders componentsJoinedByString:@"\n"];
}

#pragma mark - IDUpdatableCellViewModelProtocol
- (RACSignal *)needUpdateSignal {
    return [RACObserve(self, needUpdate) ignore:@(NO)];
}

#pragma mark - Validation
- (BOOL)validateEveryEntryField {
    
    __block BOOL isAllValid = YES;
    [self.fieldModels enumerateObjectsUsingBlock:^(IDEntryFieldCellFieldModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isAllValid &= [self validateCellFieldModel:obj];
    }];
    return isAllValid;
}

- (BOOL)validateCellFieldModel: (IDEntryFieldCellFieldModel *)cellFieldModel {
    
    BOOL isAllValid = YES;
    for (IDEntryFieldValidation *validation in cellFieldModel.validations) {
        BOOL valid = [validation isValid:cellFieldModel.rawValue];
        isAllValid &= valid;
        if (!valid) {
            
            if (!self.manualValidation) {
                self.descriptionText = validation.errorMessage;
            }
            
            return isAllValid;
        }
        else {
            if (!self.manualValidation) {
                self.descriptionText = nil;
            }
        }
    }
    return isAllValid;
}

- (void)makeAsFirstResponder {
    [self.fieldModels.firstObject makeAsFirstResponder];
}

- (RACSignal *)descriptionSignal {
    return RACObserve(self, descriptionText);
}

- (RACSignal *)stateSignal {
    return [RACObserve(self, state) skip:1];
}

#pragma mark - Helpers
- (NSString *)changedStringWithPatternHandling: (NSString *)text range: (NSRange)range {
    return [text id_changedStringWithNumericPatternHandling: text range: range];
}

- (NSString *)filteredStringWithString: (NSString *)string pattern: (NSString *)pattern {
    return [string id_stringWithPattern:pattern];
}

- (NSString *)rawStringWithFilteredString: (NSString *)string pattern: (NSString *)pattern {
    return [string id_rawStringWithPattern:pattern];
}

- (NSString *)currencyStringWithRawText: (NSString *)rawText locale: (NSLocale *)locale {
    
    NSNumberFormatter *stringFormatter = [[NSNumberFormatter alloc] init];
    stringFormatter.locale = [NSLocale localeWithLocaleIdentifier:locale.localeIdentifier];
    [stringFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [stringFormatter setMaximumFractionDigits:0];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *myNumber = [numberFormatter numberFromString:rawText];
    
    NSString *string = [stringFormatter stringFromNumber:myNumber];
    return string;
}

- (NSString *)rawCurrencyStringWithText: (NSString *)text
                                rawText: (NSString *)rawText
                            currentText: (NSString *)currentText
                                  range: (NSRange)range {
    
    NSUInteger onOriginal = 0;
    NSMutableString *rawString = [[NSMutableString alloc] init];
    
    while (onOriginal < text.length) {
        NSString *stringOriginalChar = [text substringWithRange:NSMakeRange(onOriginal, 1)];
        if (isdigit([stringOriginalChar characterAtIndex:0])) {
            [rawString appendString:stringOriginalChar];
            onOriginal++;
        }
        else {
            onOriginal++;
        }
    }
    
    if ([self singleDeleteForPatternedFieldWithText:currentText range:range]) {
        rawString = [rawText substringToIndex:[rawText length] - 1].mutableCopy;
    }
    return rawString;
}

- (NSTextAlignment)textAlignmentWithPosition: (IDEntryFieldCellElementsPosition)position {
    
    switch (position) {
        case IDEntryFieldCellElementsPositionLeft:
            return NSTextAlignmentLeft;
            break;
            
        case IDEntryFieldCellElementsPositionCenter:
            return NSTextAlignmentCenter;
            break;
            
        case IDEntryFieldCellElementsPositionRight:
            return NSTextAlignmentRight;
            break;
    }
}

- (NSString *)updatedText: (NSString *)text withTransformationType: (IDEntryFieldTransformationType)type {
    
    switch (type) {
        case IDEntryFieldTransformationTypeNone:
            return text;
            break;
            
        case IDEntryFieldTransformationTypeUppercase:
            return text.uppercaseString;
            break;
            
        case IDEntryFieldTransformationTypeLowercase:
            return text.lowercaseString;
            break;
            
        case IDEntryFieldTransformationTypeCapitalized:
            return text.capitalizedString;
            break;
    }
}

- (BOOL)singleDeleteForPatternedFieldWithText: (NSString *)text range: (NSRange)range {
    
    if (text.length < range.length) {
        return NO;
    }
    
    NSCharacterSet *numerics = [NSCharacterSet characterSetWithCharactersInString: @"0123456789"];
    NSRange numericsRange = [[text substringWithRange: range] rangeOfCharacterFromSet: numerics];
    return range.length == 1 && numericsRange.location == NSNotFound;
}

@end;


