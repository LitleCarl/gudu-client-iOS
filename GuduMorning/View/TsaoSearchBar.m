//
//  TsaoSearchBar.m
//  GuduMorning
//
//  Created by Macbook on 15/8/12.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoSearchBar.h"

@implementation TsaoSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.barTintColor = COLOR(7, 170, 153, 1);
        self.searchBarStyle = UISearchBarStyleMinimal;
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    }
    return self;
}

/**
 *  设置自定义图片
 */
- (void)setSearchIconToFavicon {
    UITextField *searchField = [self valueForKey:@"_searchField"];
    if (searchField) {
        UIImage *image = [[UIImage imageNamed: @"search"] imageTintedWithColor:[UIColor whiteColor]];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        searchField.leftView = iView;
    }
}

/**
 *  返回内部的text field
 *
 *  @return UITextField
 */
- (UITextField *)tsaoTextField{
    return [self valueForKey:@"_searchField"];
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [self setSearchIconToFavicon];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
