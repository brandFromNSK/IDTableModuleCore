//
//  IDEntryTextView.m
//  AFA
//
//  Created by Andrey Bronnikov on 29.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import "IDEntryTextView.h"

@implementation IDEntryTextView

@synthesize showFloatingLabel = _showFloatingLabel;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self defaultInitialize];
    }
    return self;
}

- (instancetype)initWithCoder: (NSCoder *)coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self defaultInitialize];
    }
    return self;
}

- (instancetype)initWithFrame: (CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self defaultInitialize];
    }
    return self;
}

- (void)defaultInitialize {

    //TODO: Move to model if needed
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.animateEvenIfNotFirstResponder = NO;
    self.scrollEnabled = NO;
}

- (void)setShowFloatingLabel:(BOOL)showFloatingLabel {
    _showFloatingLabel = showFloatingLabel;
    self.floatingLabel.hidden = !showFloatingLabel;
    [self setNeedsLayout];
}



@end
