//
//  RandomRecommendViewOwner.m
//  GuduMorning
//
//  Created by Macbook on 11/3/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "RandomRecommendViewOwner.h"
#import "StoreIndexViewController.h"
#import "KLCPopup.h"
@implementation RandomRecommendViewOwner
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setUpTrigger{
    
    [logoImageView.superview bringSubviewToFront:logoImageView];
    [RACObserve(self, store) subscribeNext:^(StoreModel *store) {
        tintTitleLabel.text = [NSString stringWithFormat:@"千辛万苦推荐您:%@" ,store.name];
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:store.logo_filename]];
        monthSaleLabel.text = [NSString stringWithFormat:@"%@份", store.month_sale];
        backRatioLabel.text = [NSString stringWithFormat:@"%d%%", (NSInteger)(store.back_ratio.floatValue * 100)];
        mainFoodListLabel.text = store.main_food_list;
        
    }];
    
    [[enterStoreBTN rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TsaoLog(@"dada");
        if (self.store) {
            StoreIndexViewController *storeIndexViewController = [kMainStoryBoard instantiateViewControllerWithIdentifier:kStoreIndexViewControllerStoryboardId];
            storeIndexViewController.store_id = [self.store id];
            [self.sourceController.navigationController pushViewController:storeIndexViewController animated:YES];
            [KLCPopup dismissAllPopups];
        }
    }];

}

@end
