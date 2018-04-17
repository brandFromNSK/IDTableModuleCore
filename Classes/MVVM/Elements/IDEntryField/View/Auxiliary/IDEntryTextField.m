//
//  IDEntryTextField.m
//  AFA
//
//  Created by Andrey Bronnikov on 29.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import "IDEntryTextField.h"

@interface IDEntryTextField ()

@property (assign, nonatomic) CGSize actualSize;

@end

@implementation IDEntryTextField

@synthesize editable = _editable;
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
    
    self.actualSize = CGSizeMake(0, 60);
    self.floatingLabelYPadding = 10.f;
    self.keepBaseline = NO;
    self.animateEvenIfNotFirstResponder = NO;
}

- (CGSize)intrinsicContentSize {

    CGSize size = [super intrinsicContentSize];
    if (size.height > self.actualSize.height) {
        self.actualSize = size;
    }
    return self.actualSize;
}

- (void)setShowFloatingLabel:(BOOL)showFloatingLabel {
    _showFloatingLabel = showFloatingLabel;
    self.floatingLabel.hidden = !showFloatingLabel;
    [self setNeedsLayout];
}

@end
