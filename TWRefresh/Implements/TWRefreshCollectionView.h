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
//  TWRefreshCollectionView.h
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TWRefresh.h"
#import "TWRefreshType.h"

@protocol TWCollectionViewRefreshingDelegate;

@interface TWRefreshCollectionView : UICollectionView

//Refresh Delegate
@property (nonatomic, weak) id<TWCollectionViewRefreshingDelegate> refreshDelegate;

@property (nonatomic, assign) TWRefreshType refreshType;

// Constructors
- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)refresyType;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout refreshType:(TWRefreshType)refreshType;

@end

@protocol TWCollectionViewRefreshingDelegate <NSObject>

@optional
- (void) beginRefreshHeader:(TWRefreshCollectionView*) collectionView;
- (void) beginRefreshFooter:(TWRefreshCollectionView*) collectionView;

@end
