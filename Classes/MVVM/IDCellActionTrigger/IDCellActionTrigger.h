//
//  IDCellActionTrigger.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 16.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    IDCellActionUpdate,
    IDCellActionInsert,
    IDCellActionDelete
} IDCellAction;

@interface IDCellActionTrigger : NSObject

+ (instancetype)trigger;
- (instancetype)withAction: (IDCellAction)action atRow: (NSInteger)row;

- (NSArray <NSIndexPath *> *)indexPathsWithAction: (IDCellAction)action;

@end
