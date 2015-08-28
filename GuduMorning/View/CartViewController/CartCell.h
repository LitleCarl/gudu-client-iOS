//
//  CartCell.h
//  Mega
//
//  Created by Sergey on 1/30/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView* productImageView;

@property(nonatomic, weak) IBOutlet UILabel* titleLabel;

@property(nonatomic, weak) IBOutlet UILabel* detailsLabel;

@property(nonatomic, weak) IBOutlet UILabel* priceLabel;

@property(nonatomic, weak) IBOutlet UILabel* quantityLabel;

@property(nonatomic, weak) IBOutlet UITextField* quantityTextField;

@end
