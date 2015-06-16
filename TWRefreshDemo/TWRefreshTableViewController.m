//
//  TWRefreshTableViewController.m
//  TWRefreshDemo
//
//  Created by Chris on 16/6/15.
//  Copyright (c) 2015 EasyBaking. All rights reserved.
//

#import "TWRefreshTableViewController.h"
#import "TWRefreshTableView.h"

@interface TWRefreshTableViewController (TableDelegate) <UITableViewDelegate, UITableViewDataSource, TWTableViewRefreshingDelegate>

@end

@implementation TWRefreshTableViewController
{
    TWRefreshTableView *_tableView;
    int _count;
}

- (void) dealloc {
    NSLog(@"############## dealloc: %@", self);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TWRrefrsh Table View";
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    _count = 10;
    
    _tableView = [[TWRefreshTableView alloc] initWithFrame:self.view.bounds refreshType:TWRefreshTypeTop|TWRefreshTypeBottom];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.refreshDelegate = self;
    [self.view addSubview:_tableView];
}

@end

@implementation TWRefreshTableViewController (TableDelegate)

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"What king of data is here. %ld", (long)indexPath.row];
    return cell;
}

- (void) stopHeader {
    _count = 10;
    [_tableView stopHeaderRefreshing];
    [_tableView reloadData];
}

- (void) stopFooter {
    _count+=10;
    [_tableView stopFooterRefreshing];
    [_tableView reloadData];
}

- (void) beginRefreshHeader:(TWRefreshTableView *)tableView {
    [self performSelector:@selector(stopHeader) withObject:nil afterDelay:2.0];
}

- (void) beginRefreshFooter:(TWRefreshTableView *)tableView {
    [self performSelector:@selector(stopFooter) withObject:nil afterDelay:2.0];
}

@end