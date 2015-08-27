//
//  CartCell.m
//  Mega
//
//  Created by Sergey on 1/30/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "CartCell.h"
#import "MegaTheme.h"

@implementation CartCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.detailsLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:12];
    
    self.detailsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    self.priceLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:15];
    
    self.priceLabel.textColor = [UIColor blueColor];
    
    self.quantityLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:12];
    
    self.quantityLabel.textColor =[ UIColor colorWithWhite:0.4 alpha:1.0];
    
    self.quantityLabel.text = @"Qty";
    
    self.productImageView.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    
    self.productImageView.layer.borderWidth = 0.4;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
