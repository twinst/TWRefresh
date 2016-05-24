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
    BOOL _autoLoad;
    TWRefreshType _refreshType;
}

- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)type {
    return [self initWithFrame:frame refreshType:type andAutoLoad:YES];
}

- (id)initWithFrame:(CGRect)frame andAutoLoad:(BOOL)autoLoad {
    return [self initWithFrame:frame refreshType:TWRefreshTypeTop|TWRefreshTypeBottom andAutoLoad:autoLoad];
}

- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)type andAutoLoad:(BOOL)autoLoad {
    self = [super initWithFrame:frame];
    if (self) {
        _refreshType = type;
        _autoLoad = autoLoad;
        [self prepareRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout refreshType:(TWRefreshType)refreshType andAutoLoad:(BOOL)autoLoad {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _autoLoad = autoLoad;
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (void)prepareRefresh {
    //self.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    if((_refreshType & TWRefreshTypeTop) == TWRefreshTypeTop){
        [self setRefreshHeaderWithIndicatorClass:[TWRefreshIndicatorView class]];
    }
    if((_refreshType & TWRefreshTypeBottom) == TWRefreshTypeBottom){
        [self setRefreshFooterWithIndicatorClass:[TWRefreshIndicatorView class]];
    }
}

- (void)refreshHeader {
    [super refreshHeader];
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshHeader:)]) {
        [self.refreshDelegate beginRefreshHeader:self];
    }
}

- (void)refreshFooter {
    [super refreshFooter];
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshFooter:)]) {
        [self.refreshDelegate beginRefreshFooter:self];
    }
}

@end
