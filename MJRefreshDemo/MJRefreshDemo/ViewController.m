//
//  ViewController.m
//  MJRefreshDemo
//
//  Created by GFK on 16/12/14.
//  Copyright © 2016年 GFK. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>

NSUInteger currentPage = 0;

@interface ViewController ()<UITableViewDataSource>
@property(nonatomic, strong) UITableView *testTableView;
// tableView总数据,相当于数据库中的数据
@property(nonatomic, strong) NSMutableArray *tableViewDataArray;
/** talbeView当前获取到的数据 */
@property(nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation ViewController

- (NSMutableArray *)tableViewDataArray {
    
    if (!_tableViewDataArray) {
        _tableViewDataArray = [NSMutableArray array];
    }
    return _tableViewDataArray;
}


- (NSMutableArray *)modelArray {
    
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView *testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
    _testTableView = testTableView;
    testTableView.dataSource = self;
    testTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testTableView];
    // 添加上拉刷新控件
    testTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    // 添加下拉刷新控件
    testTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
    
    for (int i = 0 ; i < 500; i++) {
        int number =  arc4random_uniform(100000);
        NSLog(@"number = %d", number);
        [self.tableViewDataArray addObject:@(number)];
    }
    NSLog(@"%@", self.modelArray);
    self.modelArray =  [self getDataWithCurrentPage:currentPage];
    NSLog(@"%@", self.modelArray);
}

/** 上拉刷新 */
- (void)pullRefresh {

    
    NSLog(@"上拉刷新");
    // 加载数据页面加1
    currentPage += 1;
    NSLog(@"当前加载的页数是:%lu", currentPage);
    NSLog(@"加载前数组长度:%ld", self.modelArray.count);
    [self.modelArray addObjectsFromArray:[self getDataWithCurrentPage:currentPage]];
//    [self.testTableView.mj_footer endRefreshing];
//    [self.testTableView reloadData];
    // 延迟5秒结束数据刷新,用于模拟网络加载延迟
    [self.testTableView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:5];
    [self.testTableView performSelector:@selector(reloadData) withObject:nil afterDelay:5];
    
    NSLog(@"加载后数组长度:%ld", self.modelArray.count);
}


/** 下拉刷新 */
- (void)dropDownRefresh {
    
    NSLog(@"下拉刷新");
    currentPage = 0;
    // 清空数据
    [self.modelArray removeAllObjects];
    [self.modelArray addObjectsFromArray:[self getDataWithCurrentPage:currentPage]];
    [self.testTableView.mj_header endRefreshing];
    [self.testTableView reloadData];
}


// 获取数据
- (NSMutableArray *)getDataWithCurrentPage:(NSUInteger)currentPate {

    NSMutableArray *tempArray = [NSMutableArray array];
    // 从第startIndex开始获取数据
    NSUInteger startIndex = currentPage * 20;// 每次返回20条数据
    // 从第endIndex条数据截止获取
    NSUInteger endIndex = (currentPage + 1) * 20 - 1;

    for (NSUInteger i = startIndex; i <= endIndex ; i++) {
        // self.tableViewDataArray[i]获取到NSNumber对象
        [tempArray addObject:self.tableViewDataArray[i]];
    }
    return tempArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.modelArray[indexPath.row]];
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

@end
