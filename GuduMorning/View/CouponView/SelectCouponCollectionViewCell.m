//
//  SelectCouponCollectionViewCell.m
//  GuduMorning
//
//  Created by Macbook on 11/7/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "SelectCouponCollectionViewCell.h"
@interface SelectCouponCollectionViewCell() {
    __weak IBOutlet UILabel *remainingTimeLabel;
    __weak IBOutlet UILabel *leastPriceLabel;
    __weak IBOutlet UILabel *discountLabel;
}
@end
@implementation SelectCouponCollectionViewCell

- (void)setCoupon:(CouponModel *)coupon{
    _coupon = coupon;
    [[RACObserve(self, coupon) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(CouponModel *coupon) {
        if (coupon) {
            remainingTimeLabel.text = coupon.expired_date;
            NSString *discount = @"";
            if(coupon.discount.floatValue < 1){
                NSDecimalNumber *discountDecimal = [[NSDecimalNumber decimalNumberWithString:[coupon.discount stringValue]] decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:@"10"]];
                discount = [NSString stringWithFormat:@"￥%@毛", discountDecimal];
            }
            else {
                discount = [NSString stringWithFormat:@"￥:%@元", coupon.discount];
            }
            
            leastPriceLabel.text = [NSString stringWithFormat:@"最低消费:￥%@", coupon.least_price];
            discountLabel.text = discount;
        }
    }];
    [[RACObserve(self, currentPrice) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        if (self.currentPrice.floatValue >= self.coupon.least_price.floatValue) {
            self.colorBackgroundView.backgroundColor = ColorFromRGB(0xE74C3C);
        }
        else{
            self.colorBackgroundView.backgroundColor = ColorFromRGB(0x666666);
        }
    }];
}
@end
