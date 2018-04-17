//
//  IDValidatableCellViewModelProtocol.h
//  AFA
//
//  Created by Andrey Bronnikov on 18.01.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDValidatableCellViewModelProtocol <NSObject>

- (BOOL)validate;

@optional
- (NSString *)nonValidText;

@end
