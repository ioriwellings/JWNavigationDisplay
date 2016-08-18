//
//  JWTestViewController.m
//  JWHeaderScaleImage
//
//  Created by evenCoder on 16/8/18.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWTestViewController.h"
#import "UINavigationBar+JWExtention.h"

@interface JWTestViewController() <UITableViewDelegate, UITableViewDataSource>


@end

@implementation JWTestViewController

static NSString *const cellID = @"cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Title";
    
    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.showsVerticalScrollIndicator = NO; // 不显示垂直滚动条
    // 设置tableView头部视图，必须设置头部视图背景颜色为ClearColor
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kate"]];
    imageView.frame = CGRectMake(0, 0, 0, 200);
    self.tableView.tableHeaderView = imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        
        if (offsetY >= 44) {
            
            [self setNavigationBarTransformProgress:1];
            self.navigationItem.hidesBackButton = YES; // 隐藏左侧返回按钮
            self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
        }
        else {
            
            [self setNavigationBarTransformProgress:(offsetY / 44)];
            self.navigationItem.hidesBackButton = YES; // 显示
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
    else {
        
        [self setNavigationBarTransformProgress:0];
        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
        self.navigationItem.hidesBackButton = NO;
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress {
    
    [self.navigationController.navigationBar jw_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar jw_setElementsAlpha:(1 - progress)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:150 / 255.0 blue:20 / 255.0 alpha:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar jw_reset];
}

#pragma mark - <UITableViewDataSource>
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"test";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.textColor = [UIColor orangeColor];
    
    NSString *text = nil;
    switch (indexPath.row) {
        case 0:
        {
            text = @"测试1";
            break;
        }
        case 1:
        {
            text = @"测试2";
            break;
        }
        case 2:
        {
            text = @"测试3";
            break;
        }
            
        default:
            break;
    }
    
    cell.textLabel.text = text;
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
