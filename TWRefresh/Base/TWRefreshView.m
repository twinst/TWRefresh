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
//  TWRefreshView.m
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import "TWRefreshView.h"
#import "UIScrollView+TWRefresh.h"

static NSString *TWRefreshContentOffsetKeyPath = @"contentOffset";
static NSString *TWRefreshContentInsetKeyPath = @"contentInset";
static NSString *TWRefreshContentSizeKeyPath = @"contentSize";
static NSString *TWRefreshFrameKeyPath = @"frame";

static CGFloat TWRefreshHeaderViewHeight = 54;
static CGFloat TWRefreshFooterViewHeight = 49;

@interface TWRefreshView ()
// Refresh state, indicator
- (void)setState:(TWRefreshState)state;
- (void)setIndicator:(id<TWRefreshIndicator>)indicator;

// Content inset
- (void)addRefreshContentInset:(BOOL)animated;
- (void)removeRefreshContentInset:(BOOL)animated;

- (void)layout;

// Observer handles
- (void)contentOffsetChanged:(NSDictionary *)change;
- (void)contentInsetChanged:(NSDictionary *)change;
- (void)contentSizeChanged:(NSDictionary *)change;
- (void)contentFrameChanged:(NSDictionary *)change;
@end

// Observers
@interface TWRefreshView (ObserverMethods)
- (void)addObservers;
- (void)removeObservers;
@end

@implementation TWRefreshView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Call super method
    [super willMoveToSuperview:newSuperview];
    
    // Check super view tye
    if (!newSuperview || ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    _scrollView = (UIScrollView *)newSuperview;
    
    // Work around, just get the correct original content inset
    [self performSelector:@selector(initOriginalContentInset) withObject:nil afterDelay:0.01];
    
    CGRect r = self.frame;
    r.origin.x = 0;
    r.size.width = newSuperview.frame.size.width;
    self.frame = r;
    
    // If has super view
    if (self.superview) {
        [self removeObservers];
    }
    
    // Add required observers
    [self addObservers];
}

- (void)initOriginalContentInset {
    _originalContentInset = _scrollView.contentInset;
}

- (void)removeFromSuperview {
    [self removeObservers];
    [super removeFromSuperview];
}

- (void)setIndicator:(id<TWRefreshIndicator>)indicator {
    if(_indicator != indicator) {
        if (_indicator && [_indicator isKindOfClass:[UIView class]]) {
            [((UIView *)_indicator) removeFromSuperview];
            _indicator = nil;
        }
        _indicator = indicator;
        if ([indicator isKindOfClass:[UIView class]]) {
            [self addSubview:(UIView*)indicator];
        }
    }
}

- (void)setState:(TWRefreshState)state {
    if (state == _state) {
        return;
    }
    _state = state;
    if (state == TWRefreshStateRefreshing) {
        _refreshInsetHeight = self.frame.size.height;
        
        // Set content inset
        [self addRefreshContentInset:YES];
        
        if ([_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:1.0];
        }
        
        // Start indicator
        if ([_indicator respondsToSelector:@selector(start)]) {
            [_indicator start];
        }
    }
    else if (state == TWRefreshStateNormal) {
        // Set content inset
        [self removeRefreshContentInset:YES];
        
        // Start indicator
        if ([_indicator respondsToSelector:@selector(stop)]) {
            [_indicator stop];
        }
    }
}


// Override by sub classes
- (void)addRefreshContentInset:(BOOL)animated {
    // Realization in sub class
}

- (void)removeRefreshContentInset:(BOOL)animated {
    // Realization in sub class
}

- (void)layout {
    // Realization in sub class
}

- (void)contentOffsetChanged:(NSDictionary *)change {
    // Realization in sub class
}

- (void)contentInsetChanged:(NSDictionary *)change {
    [self layout];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [self layout];
}

- (void)contentFrameChanged:(NSDictionary *)change {
    // Realization in sub class
}

@end

@implementation TWRefreshView (ObserverMethods)

- (void)addObservers {
    [_scrollView addObserver:self forKeyPath:TWRefreshContentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:TWRefreshContentInsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:TWRefreshContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:TWRefreshFrameKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:TWRefreshContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:TWRefreshContentInsetKeyPath];
    [self.superview removeObserver:self forKeyPath:TWRefreshContentSizeKeyPath];
    [self.superview removeObserver:self forKeyPath:TWRefreshFrameKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([TWRefreshContentOffsetKeyPath isEqualToString:keyPath]) {
        [self contentOffsetChanged:change];
    }
    else if ([TWRefreshContentInsetKeyPath isEqualToString:keyPath]) {
        [self contentInsetChanged:change];
    }
    else if ([TWRefreshContentSizeKeyPath isEqualToString:keyPath]) {
        [self contentSizeChanged:change];
    }
    else if ([TWRefreshFrameKeyPath isEqualToString:keyPath]) {
        [self contentFrameChanged:change];
    }
}

@end

#pragma refresh header view
@implementation TWRefreshHeaderView
{
    int _flag; // This flag just do .... work around flag
}

- (void)contentOffsetChanged:(NSDictionary*) change {
    // Call super method
    [super contentOffsetChanged:change];
    
    // Check refresh state
    if (_state==TWRefreshStateRefreshing) {
        [self adjustContentInset];
        return;
    }
    
    // Correct content inset firstly set here, assignment in willMoveToSuperView not work infact
    //_originalContentInsets = _scrollView.contentInset;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    if (_scrollView.isDragging) {
        CGFloat ratio = 0;
        BOOL invokeRatio = NO;
        CGFloat offsetY = contentOffset.y+_originalContentInset.top;
        if (offsetY<=-self.frame.size.height) {
            _state = TWRefreshStateReadyToRefresh;
        }
        else {
            _state = TWRefreshStateNormal;
        }
        if (offsetY<0) {
            ratio = MAX(0, MIN(-offsetY/self.frame.size.height, 1.0));
            invokeRatio = YES;
        }
        if (invokeRatio && [_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:ratio];
        }
    }
    else {
        if (_state==TWRefreshStateReadyToRefresh) {
            [_scrollView refreshHeader];
        }
    }
}

- (void)adjustContentInset {
    if (_flag>0) {
        return;
    }
    // Fix: A known issue here, when table view with section header, and scroll up, a gap between top and section header
    CGPoint contentOffset = _scrollView.contentOffset;
    if (contentOffset.y>-_originalContentInset.top-_refreshInsetHeight) {
        UIEdgeInsets inset = _scrollView.contentInset;
        _refreshInsetHeight = - MIN((contentOffset.y+_originalContentInset.top), 0);
        inset.top = _originalContentInset.top +_refreshInsetHeight;
        _scrollView.contentInset = inset;
    }
    else {
        UIEdgeInsets inset = _scrollView.contentInset;
        _refreshInsetHeight = MIN(-(contentOffset.y+_originalContentInset.top), self.frame.size.height);
        inset.top = _originalContentInset.top +_refreshInsetHeight;
        _scrollView.contentInset = inset;
    }
}

- (void)contentFrameChanged:(NSDictionary *)change {
    _flag = 2;
}

- (void)contentInsetChanged:(NSDictionary *)change {
    if (_state!=TWRefreshStateRefreshing) {
        _flag = 1;
        _originalContentInset = _scrollView.contentInset;
    }
    else {
        if (_flag>0) {
            _flag --;
            _originalContentInset.top = _scrollView.contentInset.top - _refreshInsetHeight;
        }
    }
    [super contentInsetChanged:change];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [super contentSizeChanged:change];
}

- (void) addRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    edgeInset.top = _refreshInsetHeight + _originalContentInset.top;
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
        _scrollView.contentOffset = CGPointMake(0, -edgeInset.top);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    // Fix inset issue, when scroll view is refresh, and push another view controller
    edgeInset.top -= _refreshInsetHeight;//=_originalContentInsets.top;
    _refreshInsetHeight = 0;
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        _flag = NO;
        if ([_indicator respondsToSelector:@selector(reset)]) {
            [_indicator reset];
        }
    }];
}

- (void)layout {
    CGRect r = self.frame;
    CGFloat indicatorHeight = 0;
    if ([_indicator respondsToSelector:@selector(indicatorHeight)]) {
        if ([_indicator indicatorHeight] > 0) {
            indicatorHeight = [_indicator indicatorHeight];
        }
    }
    if (indicatorHeight <= 0) {
        indicatorHeight = TWRefreshHeaderViewHeight;
    }
    r.size.height = indicatorHeight;
    r.origin.y = -r.size.height;
    self.frame = r;
    if (_indicator) {
        ((UIView*)_indicator).frame = self.bounds;
    }
}

@end

#pragma refresh footer view
@implementation TWRefreshFooterView

- (void)contentOffsetChanged:(NSDictionary *)change {
    
    // Call super method
    [super contentOffsetChanged:change];
    
    // Check refresh state
    if (_state == TWRefreshStateRefreshing) {
        return;
    }
    
    // Correct content inset firstly set here, assignment in willMoveToSuperView not work infact
    //_originalContentInsets = _scrollView.contentInset;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    if (_scrollView.isDragging) {
        CGFloat ratio = 0;
        BOOL invokeRatio = NO;
        CGFloat offsetY = contentOffset.y + _originalContentInset.top;
        CGFloat beginY = MAX(_scrollView.contentSize.height - _scrollView.frame.size.height + _originalContentInset.top + _originalContentInset.bottom, 0);
        if (offsetY >= beginY + self.frame.size.height) {
            _state = TWRefreshStateReadyToRefresh;
        }
        else {
            _state = TWRefreshStateNormal;
        }
        if (offsetY > beginY) {
            ratio = MAX(0, MIN((offsetY-beginY)/self.frame.size.height, 1.0));
            invokeRatio = YES;
        }
        if (invokeRatio && [_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:ratio];
        }
    }
    else {
        if (_state == TWRefreshStateReadyToRefresh) {
            [_scrollView refreshFooter];
        }
    }
}

- (void)contentInsetChanged:(NSDictionary *)change {
    /*
     if (_state!=TWRefreshStateRefreshing) {
     _originalContentInset = _scrollView.contentInset;
     }
     else {
     CGFloat top = _originalContentInset.top;
     CGFloat bottom = _originalContentInset.bottom;
     
     _originalContentInset.bottom = _scrollView.contentInset.bottom;
     _originalContentInset.bottom -= self.frame.size.height;
     
     // If scroll view content size height less than it's frame
     _originalContentInset.bottom -= MAX(_scrollView.frame.size.height-top-bottom-_scrollView.contentSize.height, 0);
     }*/
    [super contentInsetChanged:change];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [super contentSizeChanged:change];
}

- (void)addRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    edgeInset.bottom = _refreshInsetHeight + _originalContentInset.bottom + MAX(_scrollView.frame.size.height - _originalContentInset.top - _originalContentInset.bottom - _scrollView.contentSize.height, 0);
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    // Fix inset issue, when scroll view is refresh, and push another view controller
    edgeInset.bottom -= _refreshInsetHeight;//=_originalContentInsets.bottom;
    _refreshInsetHeight = 0;
    
    // If scroll view content size height less than it's frame
    edgeInset.bottom -= MAX(_scrollView.frame.size.height - _originalContentInset.top - _originalContentInset.bottom - _scrollView.contentSize.height, 0);
    
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        if ([_indicator respondsToSelector:@selector(reset)]) {
            [_indicator reset];
        }
    }];
}

- (void)layout {
    CGRect r = self.frame;
    CGFloat indicatorHeight = 0;
    if ([_indicator respondsToSelector:@selector(indicatorHeight)]) {
        if ([_indicator indicatorHeight] > 0) {
            indicatorHeight = [_indicator indicatorHeight];
        }
    }
    if (indicatorHeight <= 0) {
        indicatorHeight = TWRefreshFooterViewHeight;
    }
    r.size.height = indicatorHeight;
    r.origin.y = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height-_originalContentInset.top-_originalContentInset.bottom);
    self.frame = r;
    if (_indicator) {
        ((UIView *)_indicator).frame = self.bounds;
    }
}

@end
