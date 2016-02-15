//
//  GRPhotoBrowserSingleView.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPhotoBrowserWaitingView.h"

@interface GRPhotoBrowserSingleView : UIImageView<UIGestureRecognizerDelegate>
{
    BOOL _didCheckSize;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    UIImageView *_zoomingImageView;
    CGFloat _totalScale;
}

@property (nonatomic, strong) GRPhotoBrowserWaitingView *waitingView;
@property (nonatomic, strong) UILabel *failLabel;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

/**
 *  取消缩放
 */
- (void)cancelScale;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(BOOL success))completed;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

@end
