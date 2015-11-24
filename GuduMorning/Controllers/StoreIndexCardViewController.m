//
//  StoreIndexCardViewController.m
//  GuduMorning
//
//  Created by Macbook on 10/31/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "StoreIndexCardViewController.h"
#import "MegaTheme.h"

@interface StoreIndexCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *storeSignLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeMonthSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeBackRatio;
@property (weak, nonatomic) IBOutlet UILabel *mainFoodListLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeContactPhone;

@end

@implementation StoreIndexCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
    // Do any additional setup after loading the view.
}

- (void)setUpTrigger{
    [[self.storeLogoImageView superview] bringSubviewToFront:self.storeLogoImageView];

    [[RACObserve(self, store) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(StoreModel *store) {
        self.storeSignLabel.text = store.signature;
        self.storeNameLabel.text = kNullToString(store.name);
        self.storeMonthSaleLabel.text = kNullToString(store.month_sale);
        self.storeBackRatio.text = [NSString stringWithFormat:@"%@%%", @((NSInteger)(store.back_ratio.floatValue * 100))];
        self.mainFoodListLabel.text = kNullToString(store.main_food_list);
        self.storeContactPhone.text = [NSString stringWithFormat:@"联系电话:%@", kNullToString(store.owner.contact_phone)];
        [self.storeLogoImageView sd_setImageWithURL:[NSURL URLWithString:store.logo_filename]];

    }];
    
    [[callButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.store && self.store.owner && self.store.owner.contact_phone) {
            NSString *cleanedString = [[self.store.owner.contact_phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
            [[UIApplication sharedApplication] openURL:telURL];

        }
    }];
}

- (void)initUI{
    
    placeLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 18];
    placeLabel.textColor = [UIColor blackColor];
    
    addressLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 13];
    addressLabel.textColor = [UIColor colorWithWhite:0.43 alpha: 1.0];
    
    locationIconImageView.tintColor = [UIColor colorWithWhite:0.43 alpha: 1.0];
    locationIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    placeImageView.image = [UIImage imageNamed:@"club"];
    
    distanceLabel.text = @"1.4Km";
    distanceLabel.font = [UIFont fontWithName:MegaTheme.semiBoldFontName size:14];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabelContainer.backgroundColor = [UIColor colorWithRed:0.34 green: 0.80 blue: 0.80 alpha: 1.0];
    distanceLabelContainer.layer.cornerRadius = 4;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
