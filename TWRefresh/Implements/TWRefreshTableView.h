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
//  TWRefreshTableView.h
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TWRefresh.h"
#import "TWRefreshType.h"

@protocol TWTableViewRefreshingDelegate;

@interface TWRefreshTableView : UITableView

//Refresh Delegate
@property (nonatomic, weak) id<TWTableViewRefreshingDelegate> refreshDelegate;

// Constructors
- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)type;
- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)type andAutoLoad:(BOOL)autoLoad;
- (id)initWithFrame:(CGRect)frame andAutoLoad:(BOOL)autoLoad;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle) style refreshType:(TWRefreshType)type andAutoLoad:(BOOL)autoLoad;

@end

@protocol TWTableViewRefreshingDelegate <NSObject>

@optional
- (void) beginRefreshHeader:(TWRefreshTableView*) tableView;
- (void) beginRefreshFooter:(TWRefreshTableView*) tableView;

@end
