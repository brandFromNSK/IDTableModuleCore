//
//  IDEntryFieldProtocol.h
//  AFA
//
//  Created by Andrey Bronnikov on 29.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDEntryFieldProtocol <NSObject, UITextInput>

@property (strong, nonatomic) NSString *text;       // current text in a entry field
@property (strong, nonatomic) NSString *placeholder;

@property (assign, nonatomic) UIKeyboardType keyboardType;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (assign, nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic) BOOL showFloatingLabel;

//@property (strong, nonatomic) NSString *identifier;
//
//@property (assign, nonatomic) UIReturnKeyType returnKeyType;

//@property (strong, nonatomic) UIView *inputAccessoryView;
//@property (strong, nonatomic) UIView *inputView;
//@property (assign, nonatomic, readonly) BOOL isFirstResponder;
//
//- (void)replaceText: (NSString *)text;
//- (void)replaceText: (NSString *)text force: (BOOL)force; // YES not calls change method of protocol

@end
