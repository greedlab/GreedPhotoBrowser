//
//  GRPhotoBrowserSingleView.m
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import "GRPhotoBrowserSingleView.h"
#import "UIImageView+WebCache.h"
#import "GRPhotoBrowserConfig.h"
#import "Masonry.h"

@implementation GRPhotoBrowserSingleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        
        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
    }
    return self;
}

#pragma mark - public

- (BOOL)isScaled
{
    return  1.0 != _totalScale;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(BOOL success))completed
{
    GRPhotoBrowserWaitingView *waiting = [[GRPhotoBrowserWaitingView alloc] init];
    waiting.mode = GRPhotoBrowserWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    WeakSelf(weakSelf);
    [waiting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.width.equalTo(@100);
    }];
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.progress = (CGFloat)receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf removeWaitingView];
        if (error) {
            [_failLabel setHidden:NO];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_failLabel setHidden:YES];
            });
            if (completed) {
                completed(NO);
            }
        } else {
            _scrollImageView.image = image;
            [_scrollImageView setNeedsDisplay];
            if (completed) {
                completed(YES);
            }
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder completed:nil];
}

#pragma mark - getter

- (UILabel *)failLabel {
    if (_failLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, 160, 30);
        label.text = @"图片加载失败";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        _failLabel = label;
    }
    return _failLabel;
}

#pragma mark - setter

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;
}

#pragma mark - action

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer
{
    [self prepareForImageViewScaling];
    CGFloat scale = recognizer.scale;
    CGFloat temp = _totalScale + (scale - 1);
    [self setTotalScale:temp];
    recognizer.scale = 1.0;
}

- (void)setTotalScale:(CGFloat)totalScale
{
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)) return; // 最大缩放 2倍,最小0.5倍
    [self zoomWithScale:totalScale];
}

- (void)zoomWithScale:(CGFloat)scale
{
    _totalScale = scale;
    
    _zoomingImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (scale > 1) {
        CGFloat contentW = _zoomingImageView.frame.size.width;
        CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
        
        _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScroolView.contentSize = CGSizeMake(contentW, contentH);
        
        CGPoint offset = _zoomingScroolView.contentOffset;
        offset.x = (contentW - _zoomingScroolView.frame.size.width) * 0.5;
        _zoomingScroolView.contentOffset = offset;
    } else {
        _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
        _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingImageView.center = _zoomingScroolView.center;
    }
}

- (void)doubleTapToZommWithScale:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    [UIView animateWithDuration:0.3 animations:^{
        [self zoomWithScale:scale];
    }];
}

- (void)prepareForImageViewScaling
{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = GRPhotoBrowserBackgrounColor;
        _zoomingScroolView.contentSize = self.bounds.size;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageVieH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageVieH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageVieH);
        zoomingImageView.center = _zoomingScroolView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingImageView = zoomingImageView;
        
        [_zoomingScroolView addSubview:zoomingImageView];
        [self addSubview:_zoomingScroolView];
    }
}

- (void)scaleImage:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    [self setTotalScale:scale];
}

// 清除缩放
- (void)cancelScale
{
    [self clear];
    _totalScale = 1.0;
}

- (void)clear
{
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    [_zoomingImageView removeFromSuperview];
    _zoomingImageView = nil;
}

- (void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}

#pragma mark - private

- (void)initView {
    
}

- (void)setConstraints {
    
}

@end
