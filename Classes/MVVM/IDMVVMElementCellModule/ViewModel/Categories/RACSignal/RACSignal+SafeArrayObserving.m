//
//  RACSignal+SafeArrayObserving.m
//  AFA
//
//  Created by Andrey Bronnikov on 03.02.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "RACSignal+SafeArrayObserving.h"

#import "IDUpdatableCellViewModelProtocol.h"
#import "IDValidatableCellViewModelProtocol.h"

@implementation RACSignal (SafeArrayObserving)

- (RACSignal *)id_safeUpdatableProtocolObservingSignal {
    
   return [[self map:^id (NSArray *viewModels) {
        RACSequence *needUpdateSignals = [[viewModels.rac_sequence
                                           filter:^BOOL(id value) {
                                               return [value conformsToProtocol:@protocol(IDUpdatableCellViewModelProtocol)];
                                           }] map:^id _Nullable(id <IDUpdatableCellViewModelProtocol> value) {
                                               return value.needUpdateSignal;
                                           }];
        
        return [RACSignal merge:needUpdateSignals];
   }] switchToLatest];
}

- (RACSignal *)id_safeValidatableProtocolSignal {
    
    return [[self map:^id (NSArray *viewModels) {
        
        RACSequence *validateSignals = [viewModels.rac_sequence map:^id _Nullable(id value) {
                                             if ([value conformsToProtocol:@protocol(IDValidatableCellViewModelProtocol)]) {
                                                 return [RACSignal return:@([value validate])];
                                             }
                                             return [RACSignal return:@YES];
                                         }];

        return [[RACSignal combineLatest:validateSignals] and];
    }] switchToLatest];
}

@end
