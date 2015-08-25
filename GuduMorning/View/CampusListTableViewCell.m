//
//  CampusListTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/8/23.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CampusListTableViewCell.h"

@implementation CampusListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCampus:(CampusModel *)campus{
    _campus = campus;
    self.campusAddressLabel.text = campus.address;
    self.campusNameLabel.text = campus.name;
    
}

@end
