//
//  SelectCouponCollectionViewCell.h
//  GuduMorning
//
//  Created by Macbook on 11/7/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCouponCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CouponModel *coupon;
@property (weak, nonatomic) IBOutlet UIView *colorBackgroundView;
// 当前购物车价格
@property (nonatomic, copy) NSNumber *currentPrice;
@end
