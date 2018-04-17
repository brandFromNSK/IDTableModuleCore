//
//  RACSignal+SafeArrayObserving.h
//  AFA
//
//  Created by Andrey Bronnikov on 03.02.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (SafeArrayObserving)

- (RACSignal *)id_safeUpdatableProtocolObservingSignal;
- (RACSignal *)id_safeValidatableProtocolSignal;

@end
