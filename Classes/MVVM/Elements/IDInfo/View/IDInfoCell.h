//
//  IDInfoCell.h
//  Improve Digital
//
//  Created by Andrey Bronnikov on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDTableViewCell.h"

@interface IDInfoCell : IDTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
