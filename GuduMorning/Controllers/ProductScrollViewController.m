//
//  ProductScrollViewController.m
//  Mega
//
//  Created by Sergey on 1/31/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "ProductScrollViewController.h"
#import "MegaTheme.h"
#import "ProductImageCell.h"
#import "CartViewController.h"
// View
#import "ADVProgressControl.h"

// Category
#import "UIViewController+CustomNavLeftItem.h"

// Library
#import <ActionSheetPicker.h>
#import <MDSnackbar.h>
@interface ProductScrollViewController ()
{
    CGFloat productImageHeight;
}

/**
 *  fetch的模型数据
 */
@property (nonatomic, strong) ProductModel *product;

/**
 *  选中的规格
 */
@property (nonatomic, strong) SpecificationModel *selectedSpecification;

@end

@implementation ProductScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setUpTrigger{
    [[[specificationSelectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:specificationSelectButton.rac_willDeallocSignal] subscribeNext:^(UIButton *button) {
        
        NSArray *specificationValues = [self.product.specifications valueForKeyPath:@"@distinctUnionOfObjects.value"];
        if (specificationValues.count > 0) {
            
            NSInteger currentSelectIndex = [self.product.specifications indexOfObject:self.selectedSpecification];
            
            ActionSheetStringPicker *specPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择规格" rows:specificationValues initialSelection:currentSelectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                self.selectedSpecification = [self.product.specifications objectAtIndex:selectedIndex];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:specificationSelectButton];
            [specPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil]];
            [specPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:nil action:nil]];

            [specPicker showActionSheetPicker];
        }
    }];
    
    [[[RACObserve(self, product) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ProductModel *model) {
        titleLabel.text = [model name];
        stockLabel.text = [NSString stringWithFormat:@"类别:%@", [model category]];
// NSMutableAttributedString* salePrice = [[NSMutableAttributedString alloc] initWithString:@""];
//        [salePrice addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, salePrice.length)];
        saleLabel.text = @" ";//salePrice;
        descriptionLabel.text = [model brief];
        
        if (model.specifications.count > 0) {
            self.selectedSpecification = [model.specifications firstObject];
        }
        else{
            self.selectedSpecification = nil;
        }
        [productCollectionView reloadData];
        
    }];
    
    [[RACObserve(self, product) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ProductModel *product) {
        if (product.nutrition) {
            energyProgressView.hidden = NO;
            energyProgressView.labelText = [NSString stringWithFormat:@"热量:%@KJ",product.nutrition.energy];
                energyProgressView.progress = MIN(product.nutrition.energy.integerValue / 550.0, 0.98);
        }
        else {
            energyProgressView.hidden = YES;
        }
    }];
    
    [[[RACObserve(self, selectedSpecification) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(SpecificationModel *specification) {
        if (specification == nil) {
            colorLabel.text = @"(~>__<~) ";
            colorValueLabel.text = @"";
            priceLabel.text = @"售罄";
            priceLabel.textColor = kRedColor;
            sizeLabel.text = @"库存";
            sizeValueLabel.text = @"0";
            self.title = [NSString stringWithFormat:@"%@(已售完)",self.product.name];
        }
        else {
            colorLabel.text = specification.name;
            colorValueLabel.text = specification.value;
            priceLabel.text = [NSString stringWithFormat:@"¥%@",[specification.price stringValue]];
            priceLabel.textColor = [UIColor blueColor];
            sizeLabel.text = @"库存";
            sizeValueLabel.text = specification.stock.stringValue;
            self.title = self.product.name;
        }
        
    }];
    
    //order Button的enable属性绑定
//    RAC(orderButton, enabled) = [[RACObserve(self, selectedSpecification) takeUntil:self.rac_willDeallocSignal] map:^id(SpecificationModel *specification) {
//        if (specification.stock.integerValue > 0) {
//            return @YES;
//        }
//        else{
//            return @NO;
//        }
//    }];
    
    [[[orderButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:orderButton.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        ProductModel *product = self.product;
        SpecificationModel *specification = self.selectedSpecification;
        
        if (specification.stock.integerValue < 1) {
            [MBProgressHUD bwm_showHUDAddedTo:kKeyWindow title:@"库存不够" animated:YES];
        }
        
        if (product && specification) {
            [CartItem addProductToCart:product specification:[specification id] mount:1 increase:1];
            MDSnackbar *snack = [[MDSnackbar alloc] initWithText:[NSString stringWithFormat:@"成功添加一个:%@", product.name] actionTitle:@"购物车" duration:1.5f];
            [snack addTarget:self action:@selector(showCart)];
            [snack show];
        }
        
    }];
    
}

/**
 *  初始化ui元素属性
 */
- (void)initUI{
    
    productImageHeight = kScreenWidth - 20;
    
    productCollectionView.dataSource = self;
    productCollectionView.delegate = self;
    nutritionCollectionView.backgroundColor =  productCollectionView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    
    productCollectionLayout.minimumLineSpacing = 10;
    productCollectionLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    productCollectionLayout.itemSize = CGSizeMake(productImageHeight - 15, productImageHeight - 15);
    
    titleLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:15];
    titleLabel.textColor = [UIColor blackColor];
    
    stockLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:11];
    stockLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    saleLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:11];
    saleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    
    priceLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:15];
    priceLabel.textColor = [UIColor blueColor];
    
    colorContainerView.backgroundColor = [UIColor whiteColor];
    sizeContainerView.backgroundColor = [UIColor whiteColor];
    spacerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    colorLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    
    colorLabel.textColor = [UIColor blackColor];
    
    sizeLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    sizeLabel.textColor = [UIColor blackColor];
    
    sizeValueLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    sizeValueLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    colorValueLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    colorValueLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    descriptionLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:13];
    
    descriptionLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
}

/**
 *  抓取数据
 */
- (void)fetchData{
    if (self.product_id) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kProductFindOneUrl stringByReplacingOccurrencesOfString:@":product_id" withString:self.product_id] params:nil];
        RACSignal *signal = [Tool GET:url parameters:nil progressInView:self.view showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                self.product = [ProductModel objectWithKeyValues:[kGetResponseData(responseObject) objectForKey:@"product"]];
            }
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCart{
    CartViewController *cart = [kCartStoryBoard instantiateViewControllerWithIdentifier:kCartViewControllerStoryBoardId];
    [self.navigationController pushViewController:cart animated:YES];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return productImageHeight;
        
    }
    else if (indexPath.row == 1) {
        return 80;
    }
    else if (indexPath.row == 3) {
        
        return 70;
        
    }else if (indexPath.row == 4) {
        
        return 120;
        
    }
    else if (indexPath.row == 5) {
        return 120;
    }
    else {
        return 52;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    
     cell.separatorInset = UIEdgeInsetsZero;
     cell.layoutMargins = UIEdgeInsetsZero;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)viewDidLayoutSubviews
{
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        
        ProductImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductImageCell" forIndexPath:indexPath];
        
        [cell.productImageView sd_setImageWithURL:kUrlFromString([[self.product.product_images objectAtIndex:indexPath.row] image_name]) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                cell.productImageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
        return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView != nutritionCollectionView)
        return self.product.product_images.count;
    else
        return 7;
}




-(CGFloat) calcCellWidth :(CGSize) size {
    
    BOOL transitionToWide = size.width > size.height;
    
    
    float cellWidth = size.width / 2;
    
    if (transitionToWide) {
        
        cellWidth = size.width / 3;
        
    }
    
    return cellWidth;
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
