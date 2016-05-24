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
//  TWRefreshTableView.m
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import "TWRefreshTableView.h"
#import "TWRefreshIndicatorView.h"

@implementation TWRefreshTableView
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
    return [self initWithFrame:frame style:UITableViewStylePlain refreshType:type andAutoLoad:autoLoad];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle) style refreshType:(TWRefreshType)type andAutoLoad:(BOOL)autoLoad {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshType = type;
        _autoLoad = autoLoad;
        [self prepareRefresh];
    }
    return self;
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
