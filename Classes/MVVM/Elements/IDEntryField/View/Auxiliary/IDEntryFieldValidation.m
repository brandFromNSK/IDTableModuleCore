//
//  IDEntryFieldValidation.m
//  AFA
//
//  Created by Andrey Bronnikov on 17.01.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDEntryFieldValidation.h"

@interface IDEntryFieldValidation ()

@property (strong, nonatomic, readwrite) NSString *errorMessage;
@property (copy, nonatomic, readwrite) IDEntryFieldValidationBlock block;

@end


@implementation IDEntryFieldValidation

+ (instancetype)validationWithConditionBlock: (IDEntryFieldValidationBlock)block
                                errorMessage: (NSString *)errorMessage {
    if (self == [self class]) {
        IDEntryFieldValidation *validation = [[IDEntryFieldValidation alloc] init];
        validation.block = block;
        validation.errorMessage = errorMessage;
        return validation;
    }
    return nil;
}

- (BOOL)isValid:(NSString *)text {
    BOOL validated = self.block(text);
    return validated;
}

@end
