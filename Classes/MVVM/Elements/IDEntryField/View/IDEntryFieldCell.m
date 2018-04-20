//
//  IDEntryFieldCell.m
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 28.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import "IDEntryFieldCell.h"
#import "IDEntryTextField.h"
#import "IDEntryTextView.h"
#import "IDEntryFieldCellViewModel.h"

#import <Masonry/Masonry.h>

static const CGFloat kBottomSeparatorHeight = 1.f;
static const NSTimeInterval kBottomSeparatorAnimationDuration = 0.3f;
static CGFloat kDefaultSpaceBetweenElements = 32.f;

@interface IDEntryFieldCell () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IDEntryFieldCellViewModel *viewModel;
@property (assign, nonatomic) IDEntryFieldCellState state;

@property (assign, nonatomic) BOOL layoutSubviewsCalled;
@property (assign, nonatomic) BOOL secondaryViewModelInstalling;
@property (assign, nonatomic) BOOL viewModelUpdated;

// UI
@property (strong, nonatomic, readwrite) NSArray <UIView <IDEntryFieldProtocol> *> *entryFields;
@property (strong, nonatomic) NSArray <UIView *> *bottomSeparators;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation IDEntryFieldCell

#pragma mark - Override
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self configureViewIfNeeded];
    [self updateViewIfNeeded];
    self.viewModelUpdated = NO;
}

#pragma mark - Override
- (void)installViewModel:(IDEntryFieldCellViewModel *)viewModel {
    [super installViewModel:viewModel];
    
    self.secondaryViewModelInstalling = _viewModel ? YES : NO;
    self.viewModelUpdated = YES;
}

- (Class)viewModelClass {
    return [IDEntryFieldCellViewModel class];
}

#pragma mark - Public

- (void)bindViewModelValues {
    
    [self rac_liftSelector:@selector(updateCellWithBottomText:) withSignals:[[self.viewModel.descriptionSignal skip:1]
                                                                             takeUntil:[self rac_prepareForReuseSignal]], nil];
    
    [self rac_liftSelector:@selector(updateCellWithState:) withSignals:[self.viewModel.stateSignal
                                                                        takeUntil:[self rac_prepareForReuseSignal]], nil];
    
    [self rac_liftSelector:@selector(updateCellWithValue:) withSignals:[self.viewModel.valueSignal
                                                                        takeUntil:[self rac_prepareForReuseSignal]], nil];
    
    RAC(self, backgroundColor) = [RACObserve(self.viewModel, backgroundColor)
                                  takeUntil:[self rac_prepareForReuseSignal]];
    
    @weakify(self)
    [RACObserve(self.viewModel.fieldModels.firstObject, isFirstResponderForceCalled) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        
        if (x.boolValue && self.entryFields.firstObject) {
            [self.entryFields.firstObject becomeFirstResponder];
        }
    }];
    
    [self bindEntryModels];
}

- (void)bindEntryModels {
    
    @weakify(self);
    for( IDEntryFieldCellFieldModel *fieldModel in self.viewModel.fieldModels ) {
        
        [[[RACObserve(fieldModel, rawValue) takeUntil:[self rac_prepareForReuseSignal]] deliverOnMainThread] subscribeNext:^(NSString *rawValue) {
            @strongify(self)
            
            NSUInteger index = [self.viewModel.fieldModels indexOfObject:fieldModel];
            UIView <IDEntryFieldProtocol> *entryField = self.entryFields[index];
            
            if( entryField.isFirstResponder ) {
                return;
            }
            
            entryField.text = fieldModel.value;
        }];
    }
}

#pragma mark - Private
- (void)updateViewIfNeeded {
    
    NSAssert(self.viewModel.fieldModels.count == self.entryFields.count, @"Why is different? May be cell reused wrong?");
    
    if (_viewModel && self.viewModelUpdated) {
        
        for (int i = 0; i < self.viewModel.fieldModels.count; i++) {
            
            IDEntryFieldCellFieldModel *fieldModel = self.viewModel.fieldModels[i];
            UIView <IDEntryFieldProtocol> *entryField = self.entryFields[i];
            
            entryField.placeholder = fieldModel.placeholder;
            entryField.editable = fieldModel.editable;
            entryField.showFloatingLabel = fieldModel.showFloatingLabel;
            if (@available(iOS 10.0, *)) {
                entryField.keyboardType = fieldModel.numericKeyboard ? UIKeyboardTypeASCIICapableNumberPad : UIKeyboardTypeDefault;
            } else {
                entryField.keyboardType = fieldModel.numericKeyboard ? UIKeyboardTypePhonePad : UIKeyboardTypeDefault;
            }
            
            NSTextAlignment alignment = [self.viewModel textAlignmentWithPosition:self.viewModel.position];
            entryField.textAlignment = alignment;
            self.bottomLabel.textAlignment = alignment;
            
            NSString *text = fieldModel.value;
            [self handleTextReplacementInEntryField: entryField
                                     withFieldModel: fieldModel
                                              range: NSMakeRange(0, text.length)
                                               text: text];
            
            [self entryFieldDidChange:entryField force:YES];
        }
        
        [self.contentView layoutIfNeeded];
        [self.contentView layoutSubviews];
        
        [self bindViewModelValues];
    }
}

- (void)configureViewIfNeeded {
    
    if (!_layoutSubviewsCalled) {
        _layoutSubviewsCalled = YES;
        
        if (self.secondaryViewModelInstalling) {
            [self.bottomLabel removeFromSuperview];
            [self.entryFields makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [self attachBottomLabel];
        [self configureEntryFieldsWithViewModel:self.viewModel];
    }
}

- (void)updateCellWithBottomText:(NSString *)text {
    
    self.bottomLabel.text = text;
    self.viewModel.needUpdate = YES;
}

- (void)updateCellWithState: (NSNumber *)stateNumber {
    //TODO: update with style
}

- (void)updateCellWithValue: (NSString *)value {
    
    //TODO: Handle other indexes!
    [self handleTextReplacementInEntryField: self.entryFields[0]
                             withFieldModel: self.viewModel.fieldModels[0]
                                      range: NSMakeRange(0, value.length)
                                       text: value
                                      force: YES];
}

- (void)configureEntryFieldsWithViewModel: (IDEntryFieldCellViewModel *)viewModel {
    
    NSMutableArray *textFields = [NSMutableArray new];
    NSInteger viewModelsCount = viewModel.fieldModels.count;
    self.bottomSeparators = @[];
    
    for (int i = 0; i < viewModelsCount; i++) {

        IDEntryFieldCellFieldModel *field = viewModel.fieldModels[i];
        UIView <IDEntryFieldProtocol> *entryField = [self entryFieldWithType:field.entryFieldType];
        
        
        CGFloat proportion = field.isCustomizedProportion ? field.proportion : 1.f/(CGFloat)viewModelsCount;
        entryField.secureTextEntry = field.secureTextEntry;
        [self.contentView addSubview:entryField];
        
        
        [self setupConstraintsForEntryField: entryField
                                    atIndex: i
                                 totalCount: viewModelsCount
                               previousView: i > 0 ? textFields[i - 1] : nil
                                 proportion: proportion];
        
        if (field.showSeparator) {
            UIView *separator = [self attachedSeparatorToView:entryField];
            UIColor *separatorColor = [self separatorColorWithState: self.viewModel.state];
            separator.backgroundColor = separatorColor;
            self.bottomSeparators = [self.bottomSeparators arrayByAddingObject:separator];
        }
        
        [textFields addObject:entryField];
    }
    
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
    
    self.entryFields = textFields.copy;
}


#pragma mark - <UITextViewDelegate>
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return [self entryFieldShouldBeginEditing: (UIView <IDEntryFieldProtocol> *)textView];
}

- (void)textViewDidBeginEditing: (UITextView *)textView {
    [self entryFieldDidBeginEditing: (UIView <IDEntryFieldProtocol> *)textView];
}

- (BOOL)textViewShouldEndEditing: (UITextView *)textView {
    return [self entryFieldShouldEndEditing: (UIView <IDEntryFieldProtocol> *)textView];
}

- (void)textViewDidEndEditing: (UITextView *)textView {
    [self entryFieldDidEndEditing: (UIView <IDEntryFieldProtocol> *)textView];
}

- (BOOL)textView: (UITextView *)textView shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [self entryFieldShouldReturn: (UIView <IDEntryFieldProtocol> *)textView];
        return NO;
    }
    return [self entryField: (UIView <IDEntryFieldProtocol> *)textView shouldChangeTextInRange: range replacementText: text];
}

- (void)textViewDidChange: (UITextView *)textView {
    [self entryFieldDidChange: (UIView <IDEntryFieldProtocol> *)textView force:NO];
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self entryFieldShouldBeginEditing: (UIView <IDEntryFieldProtocol> *)textField];
}

- (void)textFieldDidBeginEditing: (UITextField *)textField {
    [self entryFieldDidBeginEditing: (UIView <IDEntryFieldProtocol> *)textField];
}

- (BOOL)textFieldShouldEndEditing: (UITextField *)textField {
    return [self entryFieldShouldEndEditing: (UIView <IDEntryFieldProtocol> *)textField];
}

- (void)textFieldDidEndEditing: (UITextField *)textField {
    [self entryFieldDidEndEditing: (UIView <IDEntryFieldProtocol> *)textField];
}

#pragma mark - IDEntryField common
- (BOOL)textField: (UITextField *)textField
shouldChangeCharactersInRange: (NSRange)range
replacementString: (NSString *)string {
    
    return [self entryField: (UIView <IDEntryFieldProtocol> *)textField
    shouldChangeTextInRange: range
            replacementText: string];
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    return [self entryFieldShouldReturn: (UIView <IDEntryFieldProtocol> *)textField];
}

- (BOOL)     entryField: (UIView <IDEntryFieldProtocol> *)entryField
shouldChangeTextInRange: (NSRange)range
        replacementText: (NSString *)text {
    
    
    CGSize sizeBeforeUpdates = entryField.intrinsicContentSize;
    
    NSString *changedString = [entryField.text stringByReplacingCharactersInRange: range withString: text];
    NSInteger index = [self.entryFields indexOfObject:entryField];
    NSAssert(index != NSNotFound, @"Entry field incorrect");
    IDEntryFieldCellFieldModel *field = self.viewModel.fieldModels[index];
    
    [self handleTextReplacementInEntryField: entryField withFieldModel:field range: range text: changedString];
    
    self.bottomLabel.text = nil;

    CGSize sizeAfterUpdates = entryField.intrinsicContentSize;
    
    [entryField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(entryField.intrinsicContentSize.height +
                                self.bottomLabel.intrinsicContentSize.height);
    }];
    
    if (sizeBeforeUpdates.height != sizeAfterUpdates.height) {
        self.viewModel.needUpdate = YES;
    }

    return NO;
}

- (BOOL)entryFieldShouldBeginEditing: (UIView <IDEntryFieldProtocol> *)entryField {
    return entryField.isEditable;
}

- (void)entryFieldDidBeginEditing: (UIView <IDEntryFieldProtocol> *)entryField {
    
    [self animateSeparatorOfEntryField: entryField];
    [self updateCellWithBottomText:nil];;
}

- (void)entryFieldDidChange: (UIView <IDEntryFieldProtocol> *)entryField force: (BOOL)force {
    // never call
}

- (BOOL)entryFieldShouldEndEditing: (UIView <IDEntryFieldProtocol> *)entryField {
    return YES;
}

- (void)entryFieldDidEndEditing: (UIView <IDEntryFieldProtocol> *)entryField {
    [self validateEntryField: entryField];
}

- (BOOL)entryFieldShouldReturn: (UIView <IDEntryFieldProtocol> *)entryField {
    return YES;
}


#pragma mark - Utilities
- (void)valueDidChangeWithValue: (NSString *)value rawValue: (NSString *)rawValue keyPath: (NSString *)keyPath {
    
    if ([self.viewModel.delegate respondsToSelector:@selector(viewModel:didChangeValue:rawValue:withKeyPath:)]) {
        if (keyPath == nil) {
            // NSLog(@"Key path is nil, viewModel:didChangeValue:rawValue:withKeyPath: will not implement");
            return;
        }
        [self.viewModel.delegate viewModel:self.viewModel didChangeValue:value rawValue:rawValue withKeyPath:keyPath];
    }
}

- (void)handleTextReplacementInEntryField: (UIView <IDEntryFieldProtocol> *)entryField
                           withFieldModel: (IDEntryFieldCellFieldModel *)field
                                    range: (NSRange)range
                                     text: (NSString *)text {
    
    [self handleTextReplacementInEntryField:entryField withFieldModel:field range:range text:text force:NO];
}

- (void)handleTextReplacementInEntryField: (UIView <IDEntryFieldProtocol> *)entryField
                           withFieldModel: (IDEntryFieldCellFieldModel *)field
                                    range: (NSRange)range
                                     text: (NSString *)text
                                    force: (BOOL)force {
    
    NSString *previousValue = entryField.text;
    
    if (field.currencyMode) {
        
        if (field.pattern) {
            NSAssert(NO, @"Currency mode not works with pattern");
        }
        
        NSString *rawText = [self.viewModel rawCurrencyStringWithText:text
                                                              rawText:field.rawValue
                                                          currentText:field.value
                                                                range:range];
        
        BOOL shouldChangeText = (field.lengthLimit == 0) || (rawText.length <= field.lengthLimit);
        if (shouldChangeText) {
            
            NSString *realText = [self.viewModel currencyStringWithRawText: rawText locale: field.locale];
            
            entryField.text = realText;
            if (!force) {

                [self updateCursorPositionForEntryField:entryField
                                                  range:range
                                                newText:realText
                                           previousText:previousValue];
                
                field.rawValue = realText;
                
                [self valueDidChangeWithValue:realText
                                     rawValue:rawText
                                      keyPath:field.keyPath];
            }
        }
        return;
    }
    
    
    NSString *changedString = [self.viewModel updatedText:text withTransformationType:field.transformation];
    
    if (!field.pattern) { // Without pattern
        
        BOOL shouldChangeText = (field.lengthLimit == 0) || (changedString.length <= field.lengthLimit);
        if (shouldChangeText) {
            
            entryField.text = changedString;
            if (!force) {

                [self updateCursorPositionForEntryField:entryField
                                                  range:range
                                                newText:changedString
                                           previousText:previousValue];
                
                field.rawValue = changedString;
                
                [self valueDidChangeWithValue:changedString
                                     rawValue:changedString
                                      keyPath:field.keyPath];
            }
        }
    }
    else { // With pattern
        
        if (@available(iOS 10.0, *)) {
            entryField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        } else {
            entryField.keyboardType = UIKeyboardTypePhonePad;
        }
        
        if ([self.viewModel singleDeleteForPatternedFieldWithText:previousValue range:range]) {
            changedString = [self.viewModel changedStringWithPatternHandling:changedString range:range];
        }
        
        NSString *filteredString = [self.viewModel filteredStringWithString: changedString pattern: field.pattern];
        NSString *rawText = [self.viewModel rawStringWithFilteredString: filteredString pattern: field.pattern];
        
        if (rawText == nil) {
            rawText = filteredString;
        }
        
        BOOL shouldChangeTextWithPattern = (field.lengthLimit == 0) || (rawText.length <= field.lengthLimit);
        if (shouldChangeTextWithPattern) {
            
            entryField.text = filteredString;
            if (!force) {

                [self updateCursorPositionForEntryField:entryField
                                                  range:range
                                                newText:filteredString
                                           previousText:previousValue];
                
                field.rawValue = rawText;
                
                [self valueDidChangeWithValue:filteredString
                                     rawValue:rawText
                                      keyPath:field.keyPath];
            }
        }
    }
}

- (void)setupConstraintsForEntryField: (UIView <IDEntryFieldProtocol> *)entryField
                              atIndex: (NSInteger)index
                           totalCount: (NSInteger)totalCount
                         previousView: (UIView *)previousView
                           proportion: (CGFloat)proportion {
    
    // Single entry field
    if (index == 0 && (totalCount == 1)) {
        
        [entryField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(self.viewModel.contentInsets.left);
            make.right.equalTo(self.contentView).offset(-self.viewModel.contentInsets.right);
        }];
    }
    
    // First entry field
    else if (index == 0 && (totalCount >= 1)) {
        
        [entryField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(self.viewModel.contentInsets.left);
            make.width.mas_equalTo((self.contentView.frame.size.width
                                   - self.viewModel.contentInsets.left
                                   - self.viewModel.contentInsets.right
                                   - kDefaultSpaceBetweenElements * (totalCount - 1)) * proportion);
        }];
    }
    
    // Last entry field (proportion not works)
    else if (index == totalCount - 1) {

        [entryField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView.mas_right).offset(kDefaultSpaceBetweenElements);
            make.right.equalTo(self.contentView).offset(-self.viewModel.contentInsets.right);
        }];
    }

    // Other entry fields
    else {
        [entryField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView.mas_right).offset(kDefaultSpaceBetweenElements);
            make.width.mas_equalTo((self.contentView.frame.size.width
                                    - self.viewModel.contentInsets.left
                                    - self.viewModel.contentInsets.right
                                    - kDefaultSpaceBetweenElements * (totalCount - 1)) * proportion);
        }];
    }
    
    [entryField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomLabel.mas_top);
    }];
    
    [entryField sizeToFit];
}


#pragma mark Separator
- (UIView *)attachedSeparatorToView: (UIView <IDEntryFieldProtocol> *)view {
    
    UIView *separator = [[UIView alloc] init];
    [view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        
        if ([view isKindOfClass:[UITextView class]]) {
            make.bottom.equalTo(view.textInputView);
        }
        else {
            make.bottom.equalTo(view);
        }
        
        make.height.mas_equalTo(kBottomSeparatorHeight);
        make.width.equalTo(view);
    }];
    return separator;
}

- (void)animateSeparatorOfEntryField: (UIView <IDEntryFieldProtocol> *)entryField {
    
    NSInteger index = [self indexOfEntryField:entryField];
    
    if (self.viewModel.fieldModels[index].showSeparator) {
        [self animateSeparatorOfEntryField: entryField width:0 animated:NO];
        [self animateSeparatorOfEntryField: entryField width:entryField.frame.size.width animated:YES];
    }
}

- (void)animateSeparatorOfEntryField: (UIView <IDEntryFieldProtocol> *)entryField
                               width: (CGFloat)width
                            animated: (BOOL)animated {
    
    UIView *separator = self.bottomSeparators [[self indexOfEntryField:entryField]];
    
    NSTimeInterval duration = animated ? kBottomSeparatorAnimationDuration : 0.f;
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(entryField);
        
            if ([entryField isKindOfClass:[UITextView class]]) {
                make.bottom.equalTo(entryField.textInputView);
            }
            else {
                make.bottom.equalTo(entryField);
            }
            
            make.height.mas_equalTo(kBottomSeparatorHeight);
            make.width.mas_equalTo(width);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark Bottom label
- (void)attachBottomLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    label.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
    label.textColor = [UIColor redColor];
    self.bottomLabel = label;
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.viewModel.contentInsets.left);
        make.right.equalTo(self.contentView).offset(-self.viewModel.contentInsets.right);
        make.bottom.equalTo(self.contentView).priority(UILayoutPriorityDefaultLow);
    }];
}

#pragma mark - Helpers
- (UIView <IDEntryFieldProtocol> *)entryFieldWithType: (IDEntryFieldType)type {
    
    IDEntryFieldCellState state = self.viewModel.state;
    UIFont *floatingLabelFont = [self floatingLabelFontWithState: state];
    UIFont *textLabelFont = [self textLabelFontWithState: state];
    
    UIView <IDEntryFieldProtocol> *entryField = nil;
    switch (type) {
        case IDEntryFieldTypeTextField: {
            IDEntryTextField *textField = [[IDEntryTextField alloc] init];
            textField.floatingLabelFont = floatingLabelFont;
            textField.font = textLabelFont;
            textField.delegate = self;
            entryField = textField;
        }
            break;
            
        case IDEntryFieldTypeTextView: {
            IDEntryTextView *textView = [[IDEntryTextView alloc] init];
            textView.floatingLabelFont = floatingLabelFont;
            textView.font = textLabelFont;
            textView.delegate = self;
            entryField = textView;
        }
            break;
    }
    
    return entryField;
}

- (UIFont *)floatingLabelFontWithState: (IDEntryFieldCellState)state {
    
    switch (state) {
        case IDEntryFieldCellStateNormal:
            return [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
            
        case IDEntryFieldCellStateClear:
            return [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
    }
}

- (UIFont *)textLabelFontWithState: (IDEntryFieldCellState)state {
    
    switch (state) {
        case IDEntryFieldCellStateNormal:
            return [UIFont systemFontOfSize:18.f weight:UIFontWeightLight];
            
        case IDEntryFieldCellStateClear:
            return [UIFont systemFontOfSize:16.f];
    }
}

- (UIColor *)separatorColorWithState: (IDEntryFieldCellState)state {
    
    switch (state) {
        case IDEntryFieldCellStateNormal:
            return [UIColor lightGrayColor];
            
        case IDEntryFieldCellStateClear:
            return [UIColor clearColor];
    }
}

- (void)updateCursorPositionForEntryField: (UIView <IDEntryFieldProtocol>*)entryField
                                    range: (NSRange)range
                                  newText: (NSString *)newText
                             previousText: (NSString *)previousText {

    if (range.location != previousText.length) {
        NSInteger difference = (NSInteger)newText.length - (NSInteger)previousText.length;
        NSInteger offset = range.location + ((difference > 0) ? difference : difference + 1);
        UITextPosition *start = [entryField positionFromPosition:[entryField beginningOfDocument]
                                                          offset:offset];
        UITextPosition *end = [entryField positionFromPosition:start offset:0];
        [entryField setSelectedTextRange:[entryField textRangeFromPosition:start toPosition:end]];
    }
}

- (NSUInteger)indexOfEntryField: (UIView <IDEntryFieldProtocol> *)entryField {
    NSUInteger index = [self.entryFields indexOfObject:entryField];
    NSAssert(index != NSNotFound, @"Entry field incorrect");
    return index;
}

#pragma mark Validations
- (void)validateEntryField: (UIView <IDEntryFieldProtocol> *)entryField {
    
    NSUInteger index = [self.entryFields indexOfObject:entryField];
    NSAssert(index != NSNotFound, @"Entry field incorrect");
    IDEntryFieldCellFieldModel *fieldModel = self.viewModel.fieldModels[index];
    
    [self.viewModel validateCellFieldModel:fieldModel];
}


@end
