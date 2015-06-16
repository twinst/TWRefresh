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
