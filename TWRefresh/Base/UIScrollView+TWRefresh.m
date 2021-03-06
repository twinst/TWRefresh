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
//  UIScrollView+TWRefres.m
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import "UIScrollView+TWRefresh.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@property (nonatomic, strong) TWRefreshView *header;
@property (nonatomic, strong) TWRefreshView *footer;
@property (nonatomic, copy) void (^refreshHeaderCallback)();
@property (nonatomic, copy) void (^refreshFooterCallback)();
@end

static const NSString *TWRefreshHeaderKey = @"TWRefreshHeaderView";
static const NSString *TWRefreshFooterKey = @"TWRefreshFooterView";
static const NSString *TWRefreshHeaderCallbackKey = @"TWRefreshHeaderViewCallback";
static const NSString *TWRefreshFooterCallbackKey = @"TWRefreshFooterViewCallback";

@implementation UIScrollView (TWRefresh)

- (void)setHeader:(TWRefreshView *)header {
    objc_setAssociatedObject(self, &TWRefreshHeaderKey, header, OBJC_ASSOCIATION_RETAIN);
}

- (void)setFooter:(TWRefreshView *)footer {
    objc_setAssociatedObject(self, &TWRefreshFooterKey, footer, OBJC_ASSOCIATION_RETAIN);
}

- (TWRefreshView *)header {
    return objc_getAssociatedObject(self, &TWRefreshHeaderKey);
}

- (TWRefreshView *)footer {
    return objc_getAssociatedObject(self, &TWRefreshFooterKey);
}

- (void)setRefreshHeaderCallback:(void (^)())refreshHeaderCallback {
    objc_setAssociatedObject(self, &TWRefreshHeaderCallbackKey, refreshHeaderCallback, OBJC_ASSOCIATION_COPY);
}

- (void)setRefreshFooterCallback:(void (^)())refreshFooterCallback {
    objc_setAssociatedObject(self, &TWRefreshFooterCallbackKey, refreshFooterCallback, OBJC_ASSOCIATION_COPY);
}

- (void(^)())refreshHeaderCallback {
    return objc_getAssociatedObject(self, &TWRefreshHeaderCallbackKey);
}

- (void(^)())refreshFooterCallback {
    return objc_getAssociatedObject(self, &TWRefreshFooterCallbackKey);
}

- (void)setRefreshHeaderWithIndicatorClass:(Class)clazz {
    if ([clazz conformsToProtocol:@protocol(TWRefreshIndicator)]) {
        id<TWRefreshIndicator> indicator = [[clazz alloc] init];
        [self setRefreshHeaderIndicator:indicator];
    }
}

- (void)setRefreshHeaderIndicator:(id<TWRefreshIndicator>)indicator {
    if (!self.header) {
        TWRefreshView *refreshView = [[TWRefreshHeaderView alloc] init];
        [self addSubview:refreshView];
        self.header = refreshView;
    }
    if (indicator) {
        [self.header setIndicator:indicator];
    }
}

- (void)setRefreshFooterWithIndicatorClass:(Class)clazz {
    if ([clazz conformsToProtocol:@protocol(TWRefreshIndicator)]) {
        id<TWRefreshIndicator> indicator = [[clazz alloc] init];
        [self setRefreshFooterIndicator:indicator];
    }
}

- (void)setRefreshFooterIndicator:(id<TWRefreshIndicator>)indicator {
    if (!self.footer) {
        TWRefreshView *refreshView = [[TWRefreshFooterView alloc] init];
        [self addSubview:refreshView];
        self.footer = refreshView;
    }
    if (indicator) {
        [self.footer setIndicator:indicator];
    }
}

- (void)refreshHeader {
    if (self.header) {
        BOOL refreshRequired = [self refreshHeaderState] != TWRefreshStateRefreshing;
        [self.header setState:TWRefreshStateRefreshing];
        if (refreshRequired) {
            if (self.refreshHeaderCallback) {
                self.refreshHeaderCallback();
            }
        }
    }
}

- (void)refreshFooter {
    if (self.footer) {
        BOOL refreshRequired = [self refreshFooterState] != TWRefreshStateRefreshing;
        [self.footer setState:TWRefreshStateRefreshing];
        if (refreshRequired) {
            if (self.refreshFooterCallback) {
                self.refreshFooterCallback();
            }
        }
    }
}

- (void)stopHeaderRefreshing {
    if (self.header) {
        [self.header setState:TWRefreshStateNormal];
    }
}

- (void)stopFooterRefreshing {
    if (self.footer) {
        [self.footer setState:TWRefreshStateNormal];
    }
}

- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    [self setRefreshHeaderEnabled:refreshEnabled];
    [self setRefreshFooterEnabled:refreshEnabled];
}

- (void)setRefreshHeaderEnabled:(BOOL)refreshEnabled {
    if (refreshEnabled) {
        if (self.header && !self.header.superview) {
            [self addSubview:self.header];
        }
    }
    else {
        if (self.header && self.header.superview == self) {
            // If is refreshing, stop it to adjust content inset
            [self.header setState:TWRefreshStateNormal];
            
            // Remove from self
            [self.header removeFromSuperview];
        }
    }
}

- (BOOL)refreshHeaderEnabled {
    if (self.header && self.header.superview == self) {
        return YES;
    }
    return NO;
}

- (void)setRefreshFooterEnabled:(BOOL)refreshEnabled {
    if (refreshEnabled) {
        if (self.footer && !self.footer.superview) {
            [self addSubview:self.footer];
        }
    }
    else {
        if (self.footer && self.footer.superview == self) {
            // If is refreshing, stop it to adjust content inset
            [self.footer setState:TWRefreshStateNormal];
            
            // Remove from self
            [self.footer removeFromSuperview];
        }
    }
}

- (BOOL)refreshFooterEnabled {
    if (self.footer && self.footer.superview == self) {
        return YES;
    }
    return NO;
}

- (TWRefreshState)refreshHeaderState {
    if (self.header) {
        return self.header.state;
    }
    return TWRefreshStateUnknown;
}

- (TWRefreshState)refreshFooterState {
    if (self.footer) {
        return self.footer.state;
    }
    return TWRefreshStateUnknown;
}

@end
