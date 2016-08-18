//
//  JWHeaderScaleImageTableViewController.m
//  JWHeaderScaleImage
//
//  Created by evenCoder on 16/8/16.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "JWHeaderScaleImageTableViewController.h"
#import "JWHeaderScaleImage/UIScrollView+HeaderScaleImage.h"
#import "JWHeaderScaleImage/UINavigationBar+JWExtention.h"
#import "JWTestViewController.h"

#define NAVBAR_CHANGE_POINT 50

@interface JWHeaderScaleImageTableViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *letfBarBtn;

@property (nonatomic, strong) UIButton *rightBarBtn;

@end

@implementation JWHeaderScaleImageTableViewController

static NSString *const cellID = @"cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 设置tableView头部视图，必须设置头部视图背景颜色为ClearColor
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    // 设置tableView头部缩放图片
    self.tableView.jw_headerScaleImage = [UIImage imageNamed:@"kate"];
    
    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.showsVerticalScrollIndicator = NO; // 不显示垂直滚动条
    
    // 设置导航栏背景颜色为透明
    [self.navigationController.navigationBar jw_setBackgroundColor:[UIColor clearColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIColor *color = [UIColor colorWithRed:10 / 255.0 green:150 / 255.0 blue:20 / 255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y; // y轴偏移量
    if (offsetY > NAVBAR_CHANGE_POINT) {
        
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar jw_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        [self setupBarButtonItem];
    }
    else {
        
        [self.navigationController.navigationBar jw_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self removeBarItem];
    }
}

- (void)setupBarButtonItem {
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.title = @"测试";
}

- (void)removeBarItem {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"";
}
                                 
- (void)leftBarItemClick {
 
    NSLog(@"%s", __func__);
}

- (void)rightBarItemClick {
    
    JWTestViewController *jwVC = [[JWTestViewController alloc] init];
    [self.navigationController pushViewController:jwVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
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

@end














