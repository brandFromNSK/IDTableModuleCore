//
//  IDEntryFieldValidation.h
//  AFA
//
//  Created by Andrey Bronnikov on 17.01.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^IDEntryFieldValidationBlock) (NSString *text);

@interface IDEntryFieldValidation : NSObject

@property (strong, nonatomic, readonly) NSString *errorMessage;
@property (copy, nonatomic, readonly) IDEntryFieldValidationBlock block;

+ (instancetype)validationWithConditionBlock: (IDEntryFieldValidationBlock)block
                                errorMessage: (NSString *)errorMessage;

- (BOOL)isValid: (NSString *)text;

@end
