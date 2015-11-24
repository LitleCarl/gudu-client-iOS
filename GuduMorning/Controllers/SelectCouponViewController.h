//
//  SelectCouponViewController.h
//  GuduMorning
//
//  Created by Macbook on 11/7/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSelectCouponCollectionViewController @"kSelectCouponCollectionViewController"

@protocol SelectCouponDelegate <NSObject>

- (void)selectCoupon: (CouponModel *)coupon;

@end

@interface SelectCouponViewController : UIViewController
@property (nonatomic, assign) id<SelectCouponDelegate> delegate;
@end
