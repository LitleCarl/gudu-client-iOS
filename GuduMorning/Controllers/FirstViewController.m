//
//  FirstViewController.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

#import <RACScheduler.h>
// Library
#import "KLCPopup.h"
#import <ReactiveCocoa/UIButton+RACCommandSupport.h>

// View
#import "ChooseListView.h"

// Model
#import "CampusModel.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"首页";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"index_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[[UIImage imageNamed:@"index_tab_select"] imageTintedWithColor:kGreenColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tsaoNavTitle = @"首页";
    [self checkCampusExist];
    
    __block NSInteger index = 0;

   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 学校相关 -

/**
 *  检测是否之前选择过学校,若没选择则强制用户选择
 */
- (void)checkCampusExist{
    ChooseListModel *model = [Tool getUserDefaultByKey:@"Campus"];
    if (model == nil) {
        [self toggleCampus];    // 让用户选择学校
    }
}

/**
 *  切换学校
 */
- (void)toggleCampus{
    ASImageNode *node = [[ASImageNode alloc] init];
    node.frame = CGRectMake(0, 0, 25, 25);
    node.image = [UIImage imageNamed:@"back_button"];
    [self.tsaoContentView addSubview:node.view];
    
    
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 50)];
    [click setTitle:@"click" forState:UIControlStateNormal];
    [self.tsaoContentView addSubview:click];
    [click setTitleColor:kGreenColor forState:UIControlStateNormal];

    __weak typeof(ASImageNode *) weakNode = node;
    click.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        TsaoLog(@"node:%@",weakNode);
        return [RACSignal empty];
    }];
    
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:kAPIVersion1 requestURL:kCampusUrl params:@{@"campus_city" : @"上海市"}];
    
    RACSignal *getCampusSignal = [Tool GET:url parameters:nil];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];

    [getCampusSignal subscribeNext:^(id responseObject) {
        NSString *code = kGetResponseCode(responseObject);
        if ([code isEqualToString:kSuccessCode]) {
            NSArray *data = kGetResponseData(responseObject);
            NSMutableArray *dataSource = [CampusModel objectArrayWithKeyValuesArray:data];
            NSMutableArray *modelData = [NSMutableArray new];
                for (int i = 0; i < dataSource.count; i++) {
                    ChooseListModel *model = [[ChooseListModel alloc] init];
                    model.itemDesc = [[dataSource objectAtIndex:i] campus_name];
                    model.imageUrl = [[dataSource objectAtIndex:i] campus_logo_url];
                    model.itemId = [[dataSource objectAtIndex:i] campus_id].stringValue;
                    [modelData addObject:model];
                }
            
                ChooseListView *listView = [[ChooseListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth *0.88, kScreenHeight * 0.68) title:@"学校" dataSource:modelData cellHeight:60];
                __weak typeof(listView) weakListView = listView;
                listView.completionBlock = ^(NSInteger index){
                    [weakListView dismissPresentingPopup];
            
                };
            
                KLCPopup *popup = [KLCPopup popupWithContentView:listView showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
                [popup show];
        }
    }
     error:^(NSError *error) {
        [hud hide:YES];
    }
     completed:^{
         TsaoLog(@"completed");
        [hud hide:YES];
    }];
    
}


@end
