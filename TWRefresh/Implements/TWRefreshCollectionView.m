//
//  Copyright 2016 Chris.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  TWRefreshCollectionView.m
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import "TWRefreshCollectionView.h"
#import "TWRefreshIndicatorView.h"

@implementation TWRefreshCollectionView
{
    TWRefreshType _refreshType;
}

- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)refreshType {
    self = [super initWithFrame:frame];
    if (self) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout refreshType:(TWRefreshType)refreshType {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (void)setRefreshType:(TWRefreshType)refreshType {
    if (_refreshType != refreshType) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
}

- (void)prepareRefresh {
    if((_refreshType & TWRefreshTypeTop) == TWRefreshTypeTop){
        [self setRefreshHeaderWithIndicatorClass:[TWRefreshIndicatorView class]];
    }
    if((_refreshType & TWRefreshTypeBottom) == TWRefreshTypeBottom){
        [self setRefreshFooterWithIndicatorClass:[TWRefreshIndicatorView class]];
    }
}

- (void)refreshHeader {
    BOOL refreshRequired = [self refreshHeaderState] != TWRefreshStateRefreshing;
    [super refreshHeader];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshHeader:)]) {
            [self.refreshDelegate beginRefreshHeader:self];
        }
    }
}

- (void)refreshFooter {
    BOOL refreshRequired = [self refreshHeaderState] != TWRefreshStateRefreshing;
    [super refreshFooter];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshFooter:)]) {
            [self.refreshDelegate beginRefreshFooter:self];
        }
    }
}

@end
