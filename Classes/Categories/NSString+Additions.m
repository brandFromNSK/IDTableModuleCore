//
//  NSString+Additions.m
//  Improve Digital
//
//  Created by Andrey Bronnikov on 16.01.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *)id_withoutSpacesAtStartAndEnd {
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)id_stringWithPattern: (NSString *)pattern {
    
    NSUInteger onOriginal = 0, onFilter = 0;
    NSMutableString *outputString = [[NSMutableString alloc] init];
    
    while (onFilter < pattern.length && onOriginal < self.length) {
        char filterChar = [pattern characterAtIndex: onFilter];
        NSString *stringOriginalChar = [self substringWithRange:NSMakeRange(onOriginal, 1)];
        
        switch (filterChar) {
                
            case '#': {
                if (isdigit([stringOriginalChar characterAtIndex:0])) {
                    [outputString appendString:stringOriginalChar];
                    onOriginal++;
                    onFilter++;
                }
                else {
                    onOriginal++;
                }
                break;
            }
                
            default: {
                NSString *filterCharString = [NSString stringWithFormat:@"%c", filterChar];
                [outputString appendString:filterCharString];
                onFilter++;
                if ([filterCharString isEqualToString:stringOriginalChar]) {
                    onOriginal++;
                }
                break;
            }
        }
    }
    return [NSString stringWithString:outputString];
}

- (NSString *)id_rawStringWithPattern: (NSString *)pattern {
    
    NSMutableString *rawText = nil;
    for (int i = 0; i < self.length; i++) {
        char patternChar = [pattern characterAtIndex: i];
        char filteredChar = [self characterAtIndex: i];
        
        switch (patternChar) {
            case '#': {
                if (!rawText) {
                    rawText = [[NSMutableString alloc] initWithFormat: @"%c", filteredChar];
                }
                else {
                    [rawText appendFormat: @"%c", filteredChar];
                }
            }
                break;
                
            default:
                break;
        }
    }
    return rawText.copy;
}

- (NSString *)id_changedStringWithNumericPatternHandling: (NSString *)string range: (NSRange)range {
    
    NSString *replacingText = string;
    NSUInteger replacedLenght = 0;
    NSInteger location = range.location - 1;
    if (location > 0) {
        for (; location > 0; location--) {
            if (isdigit([string characterAtIndex: location])) {
                break;
            }
            else {
                replacedLenght++;
            }
        }
        NSRange replacingRange = NSMakeRange(range.location - range.length - replacedLenght, range.length + replacedLenght);
        replacingText = [string stringByReplacingCharactersInRange:replacingRange withString:@""];
    }
    return replacingText;
}

@end
