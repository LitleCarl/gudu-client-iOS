//
//  OrderContentViewTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/9/9.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "OrderContentViewTableViewCell.h"

@interface OrderContentViewTableViewCell (){

    /// 产品logo ImageView
    __weak IBOutlet UIImageView *productImageView;
    /// 产品名称label
    __weak IBOutlet UILabel *productNameLabel;

    /// 产品规格Label
    __weak IBOutlet UILabel *productSpecificationLabel;
    /// 产品单价label
    __weak IBOutlet UILabel *productPriceLabel;
    /// 产品数量label
    __weak IBOutlet UILabel *productQuantityLabel;
}

@end

@implementation OrderContentViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    // Configure the view for the selected state
}

- (void)setOrder_item:(OrderItemModel *)order_item{
    
    _order_item = order_item;
    [productImageView sd_setImageWithURL:kUrlFromString(order_item.product.logo_filename)];
    productNameLabel.text = order_item.product.name;
    productPriceLabel.text = [NSString stringWithFormat:@"¥%@", order_item.price_snapshot];
    productQuantityLabel.text = [NSString stringWithFormat:@"x%@", order_item.quantity.stringValue];
    productSpecificationLabel.text = [NSString stringWithFormat:@"%@:%@", order_item.specification.name, order_item.specification.value];
}

@end
