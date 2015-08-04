//
//  TsaoBaseViewController.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoBaseViewController.h"
#import "TsaoBackButton.h"
/**
 *  需要重写navigationBar的Controller都要继承此Controller
 */
@interface TsaoBaseViewController ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) TsaoBackButton *backButton;

@end

@implementation TsaoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;

    if (self.showTsaoNavigationBar) {
        UIView *navPlusStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        navPlusStatusBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:navPlusStatusBar];
        CALayer *bottomLine = [[CALayer alloc] init];
        bottomLine.frame = CGRectMake(0, kNavBarHeight - 1, kScreenWidth, 1);
        bottomLine.backgroundColor = kLineColor.CGColor;
        [navPlusStatusBar.layer addSublayer:bottomLine];
        
        UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavBarHeight - kStatusBarHeight)];
        self.tsaoNavigationBar = navBar;

        // titleLabel
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5 * kScreenWidth, kNavBarHeight - kStatusBarHeight)];
        titleLabel.font = [UIFont fontWithName:kFontBold size:kFontNormalSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [navBar addSubview:titleLabel];
        [navPlusStatusBar addSubview:navBar];
        titleLabel.center = CGPointMake(0.5 * kScreenWidth, (kNavBarHeight - kStatusBarHeight) * 0.5);
        
        self.titleLabel = titleLabel;
        
        if (self.tsaoNavTitle) {
            [titleLabel setText:self.tsaoNavTitle];
        }
        
        if ([self.navigationController viewControllers].count > 1) {
            TsaoBackButton *button = [[TsaoBackButton alloc] initWithTitle:self.tsaoBackNavTitle];
            [button addTarget:self action:@selector(backToPrev:)];
            self.backButton = button;
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, self.view.frame.size.height - kNavBarHeight)];
        [self.view addSubview:contentView];
        self.tsaoContentView = contentView;
    }
    else {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height)];
        [self.view addSubview:contentView];
        self.tsaoContentView = contentView;

    }
    
   
    // Do any additional setup after loading the view.
}

- (void)setBackButton:(TsaoBackButton *)backButton{
    _backButton = backButton;
    
    [[[[self.tsaoNavigationBar subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.tag == %ld",kBackButtonTag]] firstObject] performSelector:@selector(removeFromSuperview)];
    
    backButton.frame = CGRectMake(0, 0, backButton.frame.size.width, backButton.frame.size.height);
    backButton.center = CGPointMake(10 + backButton.frame.size.width * 0.5, self.tsaoNavigationBar.frame.size.height * 0.5);
    [self.tsaoNavigationBar addSubview:backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTsaoNavTitle:(NSString *)tsaoNavTitle{
    _tsaoNavTitle = tsaoNavTitle;
    [self.titleLabel setText:tsaoNavTitle];
}

- (void)backToPrev:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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
