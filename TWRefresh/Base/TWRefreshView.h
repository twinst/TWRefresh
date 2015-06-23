//
//  TWRefreshView.h
//  EasyBaking
//
//  Created by Chris on 9/6/15.
//  Copyright (c) 2015 iEasyNote. All rights reserved.
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