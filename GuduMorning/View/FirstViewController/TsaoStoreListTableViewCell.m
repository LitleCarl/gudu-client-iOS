//
//  TsaoStoreListTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/8/20.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoStoreListTableViewCell.h"

@interface TsaoStoreListTableViewCell ()

/**
 *  logo对应的imageview
 */
@property (nonatomic, weak) UIImageView *logoImageView;

/**
 *  店铺名称label
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  商家描述label
 */
@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UILabel *monthLabel;

@end

@implementation TsaoStoreListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight padding:(CGFloat)padding{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _padding = padding;
        _cellHeight = cellHeight;
        
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
        
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 8, CGRectGetWidth(titleLabel.frame), _cellHeight - CGRectGetMaxY(titleLabel.frame) - 10)];
        monthLabel.font = kSmallFont;
        monthLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:monthLabel];
        self.monthLabel = monthLabel;

        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), cellHeight - 30, CGRectGetWidth(titleLabel.frame), _cellHeight - CGRectGetMaxY(titleLabel.frame) - 10)];
        descLabel.font = kSmallFont;
        descLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:descLabel];
        self.descLabel = descLabel;
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStore:(StoreModel *)store{
    _store = store;
    [self.logoImageView sd_setImageWithURL:kUrlFromString(store.logo_filename) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }];
    [self.titleLabel setText:store.name];
    [self.descLabel setText:store.brief];
    [self.monthLabel setText:[NSString stringWithFormat:@"月售:%d",29]];
    [self.descLabel sizeToFit];
    [self.titleLabel sizeToFit];
    [self.monthLabel sizeToFit];
}

@end
