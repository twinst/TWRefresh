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
//  TWRefreshView.h
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import <UIKit/UIKit.h>
#import "TWRefreshIndicator.h"

typedef NS_ENUM(NSInteger, TWRefreshState) {
    TWRefreshStateNormal,
    TWRefreshStateReadyToRefresh,
    TWRefreshStateRefreshing,
};

@interface TWRefreshView : UIView
{
    // Scroll view to be pulling refresh
    UIScrollView *_scrollView;
    
    // Indicator
    __unsafe_unretained id<TWRefreshIndicator> _indicator;
    
    // Refresh state
    TWRefreshState _state;
    
    // Scroll view original content inset
    UIEdgeInsets _originalContentInset;
    
    // Refresh inset height added when refreshing
    CGFloat _refreshInsetHeight;
}

@property (nonatomic, assign) TWRefreshState state;

// Pulling refresh view
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// Refresh indicator view
@property (nonatomic, assign) id<TWRefreshIndicator> indicator;

@end

@interface TWRefreshHeaderView : TWRefreshView

@end

@interface TWRefreshFooterView : TWRefreshView

@end