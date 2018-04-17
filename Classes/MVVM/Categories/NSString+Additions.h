//
//  NSString+Additions.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 16.01.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NONNULL_STRING(string)  (string != nil) ? string : @""

@interface NSString (Additions)

- (NSString *)id_withoutSpacesAtStartAndEnd;
- (NSString *)id_stringWithPattern: (NSString *)pattern; // example with @"### - ###": @"123456" -> @"123 - 456";
- (NSString *)id_rawStringWithPattern: (NSString *)pattern; // example with @"### - ###": @"123 - 456" -> @"123456";
- (NSString *)id_changedStringWithNumericPatternHandling: (NSString *)string range: (NSRange)range; // example: @"123 - 456" -> @"125 - 6"; Cut 34

@end
