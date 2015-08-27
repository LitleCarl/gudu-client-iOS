//
//  CartCell.h
//  Mega
//
//  Created by Sergey on 1/30/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView* productImageView;

@property(nonatomic, strong) IBOutlet UILabel* titleLabel;

@property(nonatomic, strong) IBOutlet UILabel* detailsLabel;

@property(nonatomic, strong) IBOutlet UILabel* priceLabel;

@property(nonatomic, strong) IBOutlet UILabel* quantityLabel;

@property(nonatomic, strong) IBOutlet UITextField* quantityTextField;

@end
