//
//  IDEntryFieldCell.h
//  IDEntryFields
//
//  Created by Andrey Bronnikov on 28.11.2017.
//  Copyright © 2017 Improve Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDTableViewCell.h"
#import "IDEntryFieldProtocol.h"
#import "IDEntryFieldCellState.h"

@interface IDEntryFieldCell : IDTableViewCell

@property (strong, nonatomic, readonly) IBOutlet NSArray <UIView <IDEntryFieldProtocol> *> *entryFields;

@end
