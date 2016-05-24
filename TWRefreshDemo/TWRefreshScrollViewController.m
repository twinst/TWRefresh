//
//  TWRefreshScrollViewController.m
//  TWRefreshDemo
//
//  Created by Chris on 16/6/15.
//  Copyright (c) 2015 EasyBaking. All rights reserved.
//

#import "TWRefreshScrollViewController.h"
#import <TWRefresh/UIScrollView+TWRefresh.h>
#import <TWRefresh/TWRefreshIndicatorView.h>

@interface TWRefreshScrollViewController (ScrollViewDelegate) <UIScrollViewDelegate>

@end

@implementation TWRefreshScrollViewController
{
    UIScrollView *_scrollView;
    int _count;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _count = 20;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAX(_scrollView.contentSize.height, _scrollView.frame.size.height+1));
    [_scrollView setRefreshHeaderWithIndicatorClass:[TWRefreshIndicatorView class]];
    [_scrollView setRefreshFooterWithIndicatorClass:[TWRefreshIndicatorView class]];
    __weak id weakSelf = self;
    [_scrollView setRefreshHeaderCallback:^{
        [weakSelf handleRefreshHeader];
    }];
    [_scrollView setRefreshFooterCallback:^{
        [weakSelf handleRefreshFooter];
    }];
    [self.view addSubview:_scrollView];
}

- (void) stopHeader {
    [_scrollView stopHeaderRefreshing];
}

- (void) stopFooter {
    [_scrollView stopFooterRefreshing];
}

- (void) handleRefreshHeader {
    [self performSelector:@selector(stopHeader) withObject:nil afterDelay:2.0];
}

- (void) handleRefreshFooter {
    [self performSelector:@selector(stopFooter) withObject:nil afterDelay:2.0];
}

@end
