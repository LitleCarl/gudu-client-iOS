//
//  ProductTableViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/8/25.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ProductTableViewController.h"

// View
#import "ProductTableViewCell.h"

//ViewController
#import "ProductScrollViewController.h"

@interface ProductTableViewController () <UITableViewDataSource, UITableViewDelegate>

/**
 *  产品tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@end

@implementation ProductTableViewController

static NSString *cellReuseId = @"Product_Reuse_Identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[RACObserve(self, products) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [self.productTableView reloadData];
        [self.productTableView setNeedsLayout];
        [self.productTableView layoutIfNeeded];
        [self.productTableView setNeedsDisplay];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.products.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductScrollViewController *controller = [kMainStoryBoard instantiateViewControllerWithIdentifier:kProductViewControllerStoryboardId];
    controller.product_id = [[self.products objectAtIndex:indexPath.row] id];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    cell.product = [self.products objectAtIndex:indexPath.row];
    
    return cell;
}

@end
