//
//  ChooseCampusView.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ChooseListView.h"

// Category
#import "UIImage+Tint.h"

// View
#import "TsaoRoundButton.h"

#define klineHeight 1
#define padding 20
#define kPinImageViewTag 32231

// 点击了按钮之后发出通知取消其他按钮下的图钉显示
#define kTransparentClickNotificationName @"kTransparentClickNotificationName"

@implementation ChooseListModel
@end

@implementation ChooseListView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title dataSource:(NSArray *)dataSource cellHeight:(CGFloat)cellHeight{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kRoundCornerRadius;
        self.layer.shadowColor = kShadowColor.CGColor;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 30;
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        
        _title = title;
        _dataSource = dataSource;
        _cellHeight = (cellHeight <= 0) ? 45 : cellHeight;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat forkViewWidth = _cellHeight;
    CGFloat submitButtonHeight = _cellHeight;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _cellHeight + klineHeight, self.frame.size.width, self.frame.size.height - _cellHeight - klineHeight - submitButtonHeight)];
    [self addSubview:scrollView];
    
    CGFloat totalHeight = (self.dataSource.count) * (_cellHeight + klineHeight);
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, totalHeight)];
    [self addSubview:scrollView];
    
    __block CGFloat originYOffset = 0;
    
    // 创建标题Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _cellHeight)];
    titleLabel.text = self.title;
    titleLabel.textColor = ColorFromRGB(0x333333);
    titleLabel.font = [UIFont fontWithName:kFontBold size:kFontNormalSize];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    //添加长分割线
    UIView *longSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, _cellHeight, self.frame.size.width, klineHeight)];
    longSeparator.backgroundColor = kLineColor;
    [self addSubview:longSeparator];
    
    //添加提交按钮
    UIButton *submitButton = [[TsaoRoundButton alloc] initWithFrame:CGRectMake(0, 0, submitButtonHeight * 2, submitButtonHeight * 0.8)];
    submitButton.enabled = NO;
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitle:@"选择学校" forState:UIControlStateDisabled];
    submitButton.center = CGPointMake(self.frame.size.width * 0.5, CGRectGetMaxY(scrollView.frame) + submitButtonHeight * 0.5);
    [self addSubview:submitButton];
    
    if (self.dataSource.count > 0) {
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ChooseListModel *model = (ChooseListModel *)obj;
            
            UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, originYOffset, self.frame.size.width, _cellHeight)];
            
            [scrollView addSubview:wrapper];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.9 * _cellHeight, 0.9 * _cellHeight)];
            imageView.center = CGPointMake(padding + imageView.frame.size.width * 0.5, wrapper.frame.size.height * 0.5);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:kUrlFromString(model.imageUrl)] ;;
            [wrapper addSubview:imageView];
            
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + padding, 0, self.frame.size.width - padding - imageView.frame.size.width - forkViewWidth , _cellHeight)];
            itemLabel.text = model.itemDesc;
            itemLabel.textColor = ColorFromRGB(0x333333);
            itemLabel.font = [UIFont fontWithName:kFontFamily size:kFontNormalSize];
            
            [wrapper addSubview:itemLabel];

            originYOffset += _cellHeight;
            
            UIButton *transparentButton = [[UIButton alloc] init];
            transparentButton.frame = wrapper.bounds;
            transparentButton.tag = idx;
            [wrapper addSubview:transparentButton];
            
            @weakify(transparentButton);
            [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kTransparentClickNotificationName object:nil] takeUntil:transparentButton.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {

                if (transparentButton_weak_ != [[notification userInfo]objectForKey:@"sender"]) {
                        [[transparentButton_weak_.superview viewWithTag:kPinImageViewTag] setHidden:YES];
                }
                else {
                        [[transparentButton_weak_.superview viewWithTag:kPinImageViewTag] setHidden:NO];
                }
            }];
            
            [[[transparentButton rac_signalForControlEvents:UIControlEventTouchUpInside]
             takeUntil:transparentButton.rac_willDeallocSignal]
                subscribeNext:^(UIButton *sender) {
                    [submitButton setEnabled:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTransparentClickNotificationName object:nil userInfo:@{@"sender" : transparentButton_weak_}];
                }
             ];
            
            @weakify(wrapper);
            dispatch_async(kBackgroundQueue, ^{
                ASImageNode *pinImageNode = [[ASImageNode alloc] init];
                pinImageNode.image = [UIImage imageNamed:@"icon_pin"];
                pinImageNode.contentMode = UIViewContentModeScaleAspectFit;
                pinImageNode.frame = (CGRect){
                    CGPointMake(CGRectGetMaxX(itemLabel.frame), _cellHeight * 0.2),
                    CGSizeMake(_cellHeight * 0.6, _cellHeight * 0.6)
                };
                pinImageNode.hidden = YES;
                
                // self.view isn't a node, so we can only use it on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[RACObserve(pinImageNode.view, hidden) skip:1] subscribeNext:^(id x) {
                        TsaoLog(@"hidden:%@",x);
                    }];
                    pinImageNode.view.tag = kPinImageViewTag;
                    [wrapper_weak_ addSubview:pinImageNode.view];
                });
            });
            
            
            
            // 添加分割线
            if ((idx + 1) < self.dataSource.count) {
                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(padding, originYOffset, self.frame.size.width - padding * 2, klineHeight)];
                separator.backgroundColor = kLineColor;
                [scrollView addSubview:separator];
                originYOffset += klineHeight;
            }
            
        }];
        
    }
}

/**
 *  item被选中后出发的事件
 *
 *  @param sender 点击的item的按钮
 */
- (void)selectItemAtIndex:(UIButton *)sender{
    NSInteger index = sender.tag;
    
    if (self.completionBlock) {
        self.completionBlock(index);
        self.completionBlock = NULL;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(chooseListViewDidSelectItem:atIndex:)]){
        [self.delegate chooseListViewDidSelectItem:self atIndex:index];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
