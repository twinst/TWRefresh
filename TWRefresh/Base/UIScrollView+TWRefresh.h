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
//  UIScrollView+TWRefres.h
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import <UIKit/UIKit.h>
#import "TWRefreshView.h"
#import "TWRefreshIndicator.h"

@interface UIScrollView (TWRefresh)

// Set refresh Header indicator
- (void)setRefreshHeaderIndicator:(id<TWRefreshIndicator>)indicator;

// Set refresh Header with indicator class
- (void)setRefreshHeaderWithIndicatorClass:(Class)clazz;

// Set refresh Footer indicator
- (void)setRefreshFooterIndicator:(id<TWRefreshIndicator>)indicator;

// Set refresh Footer with indicator class
- (void)setRefreshFooterWithIndicatorClass:(Class)clazz;

// Stop Header Refreshing
- (void)stopHeaderRefreshing;

// Stop Footer Refreshing
- (void)stopFooterRefreshing;

// Header Refresing
- (void)refreshHeader;

// Footer Refresing
- (void)refreshFooter;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshEnabled:(BOOL)refreshEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshHeaderEnabled:(BOOL)refreshEnabled;

// Get state of refresh header enabled
- (BOOL)refreshHeaderEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshFooterEnabled:(BOOL)refreshEnabled;

// Get state of refresh footer enabled
- (BOOL)refreshFooterEnabled;

// Refresh header callback
- (void)setRefreshHeaderCallback:(void (^)())refreshHeaderCallback;

// Refresh footer callback
- (void)setRefreshFooterCallback:(void (^)())refreshFooterCallback;

// Refresh header state
- (TWRefreshState)refreshHeaderState;

// Refresh footer state
- (TWRefreshState)refreshFooterState;

@end
