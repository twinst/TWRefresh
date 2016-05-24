//
//  ViewController.m
//  TWRefreshDemo
//
//  Created by Chris on 15/6/15.
//  Copyright (c) 2015 EasyBaking. All rights reserved.
//

#import "ViewController.h"
#import <TWRefresh/TWRefreshTableView.h>

#import "TWRefreshTableViewController.h"
#import "TWRefreshCollectionViewController.h"
#import "TWRefreshScrollViewController.h"

@interface ViewController ()

@end

@interface ViewController (TableDelegate) <UITableViewDelegate, UITableViewDataSource, TWTableViewRefreshingDelegate>

@end

@implementation ViewController
{
    TWRefreshTableView *_tableView;
    NSInteger _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"TWRrefrsh";
    
    _count = 23;
    
    UIBarButtonItem *disableHeader = [[UIBarButtonItem alloc] initWithTitle:@"DH" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRefreshHeaderEnabledNo:)];
    UIBarButtonItem *disableFooter = [[UIBarButtonItem alloc] initWithTitle:@"DF" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRefreshFooterEnabledNo:)];
    self.navigationItem.rightBarButtonItems = @[disableHeader, disableFooter];
    
    UIBarButtonItem *enableHeader = [[UIBarButtonItem alloc] initWithTitle:@"EH" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRefreshHeaderEnabledYes:)];
    UIBarButtonItem *enableFooter = [[UIBarButtonItem alloc] initWithTitle:@"EF" style:UIBarButtonItemStylePlain target:self action:@selector(toggleRefreshFooterEnabledYes:)];
    self.navigationItem.leftBarButtonItems = @[enableHeader, enableFooter];
    
    _tableView = [[TWRefreshTableView alloc] initWithFrame:self.view.bounds refreshType:TWRefreshTypeTop|TWRefreshTypeBottom];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.refreshDelegate = self;
    
    [self.view addSubview:_tableView];
}

- (void) toggleRefreshHeaderEnabledNo:(UIBarButtonItem*) sender {
    [_tableView setRefreshHeaderEnabled:NO];
}

- (void) toggleRefreshHeaderEnabledYes:(UIBarButtonItem*) sender {
    [_tableView setRefreshHeaderEnabled:YES];
}

- (void) toggleRefreshFooterEnabledNo:(UIBarButtonItem*) sender {
    [_tableView setRefreshFooterEnabled:NO];
}

- (void) toggleRefreshFooterEnabledYes:(UIBarButtonItem*) sender {
    [_tableView setRefreshFooterEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ViewController (TableDelegate)

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"This is a section header";
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:label];
    return view;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = indexPath.row<3? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.textLabel.textColor = indexPath.row<3? [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0f] : [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0f];
    if (indexPath.row==0) {
        cell.textLabel.text = @"Refresh TableView";
    }
    else if (indexPath.row==1) {
        cell.textLabel.text = @"Refresh CollectionView";
    }
    else if (indexPath.row==2) {
        cell.textLabel.text = @"Refresh ScrollView";
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"What kind of data here %ld", (long)indexPath.row];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        TWRefreshTableViewController *vc = [[TWRefreshTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==1) {
        TWRefreshCollectionViewController *vc = [[TWRefreshCollectionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==2) {
        TWRefreshScrollViewController *vc = [[TWRefreshScrollViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) stopHeader {
    _count = 3;
    [_tableView stopHeaderRefreshing];
    [_tableView reloadData];
}

- (void) stopFooter {
    _count += 8;
    [_tableView stopFooterRefreshing];
    [_tableView reloadData];
}

- (void) beginRefreshHeader:(TWRefreshTableView *)tableView {
    [self performSelector:@selector(stopHeader) withObject:nil afterDelay:4.0];
}

- (void) beginRefreshFooter:(TWRefreshTableView *)tableView {
    [self performSelector:@selector(stopFooter) withObject:nil afterDelay:2.0];
}

@end
