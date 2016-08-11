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
//  TWRefreshIndicatorView.m
//  TWRefresh
//
//  Created by Chris on 24/5/2016.
//

#import "TWRefreshIndicatorView.h"

@implementation TWRefreshIndicatorView
{
    CAShapeLayer *_arcLayer;
    UIImageView *_imageView, *_wordsView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addShapeLayer];
    }
    return self;
}

- (BOOL)isFrameEquals:(CGRect)frame1 to:(CGRect)frame2 {
    return frame1.origin.x == frame2.origin.x &&
    frame1.origin.y == frame2.origin.y &&
    frame1.size.width == frame2.size.width &&
    frame1.size.height == frame2.size.height;
}

- (void)setFrame:(CGRect)frame {
    if (![self isFrameEquals:frame to:self.frame]) {
        [super setFrame:frame];
        [self adjustShapeLayerPath];
    }
}

- (void)start {
    [self startAnimation];
}

- (void)stop {
    [self removeAnimations];
}

- (void)reset {
    [self drawLineAnimationWithRatio:0];
}

- (void)pullingWithRatio:(CGFloat)ratio {
    [self drawLineAnimationWithRatio:ratio];
}

- (void)removeAnimations {
    [_arcLayer removeAnimationForKey:@"pulling.refresh.rotation"];
    [_imageView.layer removeAnimationForKey:@"pulling.refresh.rotation"];
}

-(void)addShapeLayer {
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.lineCap = kCALineCapRound;
    _arcLayer.lineJoin = kCALineJoinRound;
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
    _arcLayer.strokeColor = [UIColor redColor].CGColor;
    _arcLayer.lineWidth = 2;
    _arcLayer.strokeStart = 0;
    [self.layer addSublayer:_arcLayer];
}

- (void)adjustShapeLayerPath {
    if (_arcLayer) {
        _arcLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:12 startAngle:-M_PI_2 endAngle:2 * M_PI - M_PI_2 clockwise:YES];
        _arcLayer.path = path.CGPath;
    }
    if (_imageView) {
        _imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    if (_wordsView) {
        _wordsView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

-(void)drawLineAnimationWithRatio:(CGFloat)ratio {
    _arcLayer.strokeEnd = ratio;
    _wordsView.transform = CGAffineTransformMakeScale(ratio, ratio);
}

- (void)startAnimation {
    // Remove animation first
    [self removeAnimations];
    
    // Add animation
    _arcLayer.strokeEnd = 0.94;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.duration = 1.0;
    animation.repeatCount = INT_MAX;
    [_arcLayer addAnimation:animation forKey:@"pulling.refresh.rotation"];
}

@end
