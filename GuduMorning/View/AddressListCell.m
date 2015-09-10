//
//  AddressListCell.m
//  GuduMorning
//
//  Created by Macbook on 15/9/5.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "AddressListCell.h"

@interface AddressListCell ()
{
    __weak IBOutlet UIImageView *selectImage;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *phoneLabel;
}
@end

@implementation AddressListCell

- (void)setAddress:(AddressModel *)address{
    _address = address;
    [[RACObserve(self.address, name) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
        nameLabel.text = kNullToString(value) ;
            }];
    [[RACObserve(self.address, address) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
        addressLabel.text = kNullToString(value) ;
    }];
    [[RACObserve(self.address, phone) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *value) {
        phoneLabel.text = kNullToString(value) ;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        self.backgroundColor = kWetAsphaltColor;
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
    selectImage.hidden = !selected;
    if (selected) {
        nameLabel.textColor = [UIColor whiteColor];
        addressLabel.textColor = [UIColor whiteColor];
        phoneLabel.textColor = [UIColor whiteColor];
    }
    else {
        nameLabel.textColor = [UIColor blackColor];
        phoneLabel.textColor = [UIColor blackColor];
        addressLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
//    self.backgroundColor = [UIColor]
    selectImage.hidden = !selected;
    if (selected) {
        nameLabel.textColor = [UIColor whiteColor];
        addressLabel.textColor = [UIColor whiteColor];
        phoneLabel.textColor = [UIColor whiteColor];
    }
    else {
        nameLabel.textColor = [UIColor blackColor];
        phoneLabel.textColor = [UIColor blackColor];
        addressLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
}

@end
