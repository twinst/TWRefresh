//
//  TWRefreshCollectionViewController.m
//  TWRefreshDemo
//
//  Created by Chris on 16/6/15.
//  Copyright (c) 2015 EasyBaking. All rights reserved.
//

#import "TWRefreshCollectionViewController.h"
#import <TWRefresh/TWRefreshCollectionView.h>

@interface TWRefreshCollectionViewController (CollectionViewDelegate) <UICollectionViewDelegate, UICollectionViewDataSource, TWCollectionViewRefreshingDelegate>

@end

@implementation TWRefreshCollectionViewController
{
    TWRefreshCollectionView *_collectionView;
    int _count;
}

- (void) dealloc {
    NSLog(@"############## dealloc: %@", self);
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.title = @"TWRrefrsh Collection View";
    
    self.view.backgroundColor = [UIColor whiteColor];
    _count = 20;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:0];
    _collectionView = [[TWRefreshCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout refreshType:TWRefreshTypeTop|TWRefreshTypeBottom andAutoLoad:YES];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.refreshDelegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TWCollectionViewCell class] forCellWithReuseIdentifier:@"collection_view_cell"];
    [self.view addSubview:_collectionView];
}

@end

@implementation TWRefreshCollectionViewController (CollectionViewDelegate)

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection_view_cell" forIndexPath:indexPath];
    [cell showWithIndex:indexPath.row];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
}

- (void) stopHeader {
    _count = 10;
    [_collectionView stopHeaderRefreshing];
    [_collectionView reloadData];
}

- (void) stopFooter {
    _count+=10;
    [_collectionView stopFooterRefreshing];
    [_collectionView reloadData];
}

- (void) beginRefreshHeader:(TWRefreshCollectionView *)collectionView {
    [self performSelector:@selector(stopHeader) withObject:nil afterDelay:2.0];
}

- (void) beginRefreshFooter:(TWRefreshCollectionView *)collectionView {
    [self performSelector:@selector(stopFooter) withObject:nil afterDelay:2.0];
}

@end

@implementation TWCollectionViewCell
{
    UIView *_view;
    UILabel *_label;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _view = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
        _view.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
        _view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
        _view.layer.borderWidth = 1.0f;
        [self.contentView addSubview:_view];
        _label = [[UILabel alloc] initWithFrame:_view.bounds];
        _label.font = [UIFont boldSystemFontOfSize:64];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
        [_view addSubview:_label];
    }
    return self;
}

- (void) showWithIndex:(NSInteger)index {
    _label.text = [NSString stringWithFormat:@"%ld", (long)index];
}

@end
