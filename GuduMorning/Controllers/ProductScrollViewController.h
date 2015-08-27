//
//  ProductScrollViewController.h
//  Mega
//
//  Created by Sergey on 1/31/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductViewControllerStoryboardId @"Product_View_Controller_Storyboard_ID"

@class ADVProgressControl;

@interface ProductScrollViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

{
    IBOutlet UILabel* titleLabel;
    
    IBOutlet UILabel* stockLabel;
    
    IBOutlet UILabel* priceLabel;
    
    IBOutlet UILabel* saleLabel;
    
    IBOutlet UIView* colorContainerView;
    
    IBOutlet UIView* sizeContainerView;
    
    IBOutlet UIView* spacerView;
    
    IBOutlet UILabel* sizeLabel;
    
    IBOutlet UILabel* colorLabel;
    
    IBOutlet UILabel* sizeValueLabel;
    
    IBOutlet UILabel* colorValueLabel;
    
    IBOutlet UILabel* descriptionLabel;
    
    IBOutlet UIButton* orderButton;
    
    IBOutlet UICollectionView* productCollectionView;
    
    IBOutlet UICollectionViewFlowLayout* productCollectionLayout;
    
    __weak IBOutlet UIButton *specificationSelectButton;
    
    __weak IBOutlet UICollectionView *nutritionCollectionView;
    
    __weak IBOutlet ADVProgressControl *energyProgressView;
}

/**
 *  产品id,需要在初始化控制器的时候传入
 */
@property (nonatomic, copy) NSString *product_id;

@end
