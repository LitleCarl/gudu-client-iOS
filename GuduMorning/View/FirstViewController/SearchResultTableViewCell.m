//
//  SearchResultTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "SearchResultTableViewCell.h"

// Model
#import "ProductModel.h"

@interface SearchResultTableViewCell ()
/**
 *  店铺logo/商品图片对应的imageview
 */
@property (nonatomic, weak) UIImageView *logoImageView;

/**
 *  店铺/商品名称label
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  店铺/商品描述label
 */
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation SearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight padding:(CGFloat)padding{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _padding = padding;
        _cellHeight = cellHeight;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_padding, _padding, _cellHeight - 2 * padding, _cellHeight - 2 * padding)];
        [self addSubview:imageView];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 3.0f;
        self.logoImageView = imageView;
        
        CGFloat maxXOfImageView = CGRectGetMaxX(imageView.frame);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxXOfImageView + padding, padding, kScreenWidth - maxXOfImageView - padding, 16)];
        self.titleLabel = titleLabel;
        [titleLabel setFont:kMiddleFont];
        [self addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 10, CGRectGetWidth(titleLabel.frame), _cellHeight - CGRectGetMaxY(titleLabel.frame) - 10)];
        descLabel.font = kSmallFont;
        descLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:descLabel];
        self.descLabel = descLabel;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id)model{
    NSString *name = nil;
    NSString *desc = nil;
    NSString *logo_filename = nil;
    
    if ([model isKindOfClass:[StoreModel class]]) {
        StoreModel *store = (StoreModel *)model;
        name = [store name];
        desc = [store brief];
        logo_filename = [store logo_filename];
    }
    else if([model isKindOfClass:[ProductModel class]]){
        ProductModel *product = (ProductModel *)model;
        name = product.name;
        desc = product.brief;
        logo_filename = product.logo_filename;
    }
    TsaoLog(@"name:%@,desc:%@,logo:%@",name,desc,logo_filename);
    self.titleLabel.text = name;
    self.descLabel.text = desc;
    [self.logoImageView sd_setImageWithURL:kUrlFromString(logo_filename) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
}

@end
