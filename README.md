# TWRefresh
UIScroll View Pulling Refresh

#Classes

Base:
UIScrollView+TWRefresh.h
TWRefreshView.h
TWRefreshIndicator.h

Indicators:
TWRefreshIndicatorView.h

Implements:
TWRefreshTableView.h
TWRefreshCollectionView.h


# You can easily create your own indicators, just need to implement protocal TWRefreshIndicator

Example:

@interface CustomRefreshIndicatorView : UIView &lt;TWRefreshIndicator&gt;

@end

@implementation CustomRefreshIndicatorView

- (void) start {
}

- (void) stop {
}

- (void) pullingWithRatio:(CGFloat)ratio {
  //The value of ratio range 0.0 to 1.0. 
}

@end

# API Usage (In UIScrollView+TWRefresh.h)

// Set refresh Header indicator
- (void) setRefreshHeaderIndicator:(id<TWRefreshIndicator>) indicator;

// Set refresh Header with indicator class
- (void) setRefreshHeaderWithIndicatorClass:(Class) clazz;

// Set refresh Footer indicator
- (void) setRefreshFooterIndicator:(id<TWRefreshIndicator>) indicator;

// Set refresh Footer with indicator class
- (void) setRefreshFooterWithIndicatorClass:(Class) clazz;

# Set refresh enabled
// Set refresh enabled, sometimes you need to switch refreshable state
- (void) setRefreshEnabled:(BOOL) refreshEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void) setRefreshHeaderEnabled:(BOOL) refreshEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void) setRefreshFooterEnabled:(BOOL) refreshEnabled;

# Inheritance
// Header Refresing
- (void) refreshHeader;

// Footer Refresing
- (void) refreshFooter;

// Stop Header Refreshing
- (void) stopHeaderRefreshing;

// Stop Footer Refreshing
- (void) stopFooterRefreshing;

# Use callback
// Refresh header callback
- (void) setRefreshHeaderCallback:(void (^)())refreshHeaderCallback;

// Refresh footer callback
- (void) setRefreshFooterCallback:(void (^)())refreshFooterCallback;

