//
//  RandomRecommendViewOwner.h
//  GuduMorning
//
//  Created by Macbook on 11/3/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoundButton.h"

@interface RandomRecommendViewOwner : NSObject{

    __weak IBOutlet RoundButton *enterStoreBTN;
    __weak IBOutlet UILabel *mainFoodListLabel;
    __weak IBOutlet UILabel *backRatioLabel;
    __weak IBOutlet UILabel *monthSaleLabel;
    __weak IBOutlet UILabel *storeNameLabel;
    __weak IBOutlet UIImageView *logoImageView;
    __weak IBOutlet UILabel *tintTitleLabel;
}
@property (nonatomic, strong) StoreModel *store;

@property (nonatomic, weak) UIViewController *sourceController;
- (void)setUpTrigger;

@end
