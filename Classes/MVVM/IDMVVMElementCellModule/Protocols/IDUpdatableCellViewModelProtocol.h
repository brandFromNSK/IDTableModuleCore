//
//  IDUpdatableCellViewModelProtocol.h
//  AFA
//
//  Created by Andrey Bronnikov on 02.02.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@protocol IDUpdatableCellViewModelProtocol <NSObject>

- (RACSignal *)needUpdateSignal;

@end
