//
//  StoreIndexCardViewController.h
//  GuduMorning
//
//  Created by Macbook on 10/31/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreIndexCardViewController : UIViewController{
    IBOutlet UIImageView* placeImageView;
    IBOutlet UILabel* placeLabel;
    IBOutlet UILabel* addressLabel;
    IBOutlet UIImageView* locationIconImageView;
    
    IBOutlet UILabel* distanceLabel;
    IBOutlet UIView* distanceLabelContainer;
    
    IBOutlet UITableView* eventsTableView;
    __weak IBOutlet UILabel *contactPhoneLabel;
    
    __weak IBOutlet UIButton *callButton;
    NSArray* events;
}

@property (nonatomic, weak) StoreModel *store;

@end
