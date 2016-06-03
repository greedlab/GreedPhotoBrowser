//
//  GRPhotoBrowserSingleView.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "GRPhotoBrowserWaitingView.h"

@interface GRPhotoBrowserSingleView : UIView <UIGestureRecognizerDelegate> {
    MASConstraint *_imageViewHeightConstraint;
    MASConstraint *_imageViewWidthConstraint;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GRPhotoBrowserWaitingView *waitingView;
@property (nonatomic, strong) UILabel *failLabel;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)setScale:(CGFloat)scale animate:(BOOL)animate;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(BOOL success))completed;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)updateForScale:(CGFloat)scale animate:(BOOL)animate;

@end
