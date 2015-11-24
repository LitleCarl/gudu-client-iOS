//
//  ProductTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/8/25.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ProductTableViewCell.h"

@interface ProductTableViewCell ()

/**
 *  产品imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

/**
 *  产品名字标签
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

/**
 *  产品价格标签
 */
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

/**
 *  月售标签
 */
@property (weak, nonatomic) IBOutlet UILabel *monthSaleLabel;

@end

@implementation ProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setProduct:(ProductModel *)product{
    _product = product;
    [self.productImageView sd_setImageWithURL:kUrlFromString(product.logo_filename)];
    self.productNameLabel.text = product.name;
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%@~¥%@", product.min_price, product.max_price];
    self.monthSaleLabel.text = [NSString stringWithFormat:@"月售:%@", product.month_sale];
}

@end
