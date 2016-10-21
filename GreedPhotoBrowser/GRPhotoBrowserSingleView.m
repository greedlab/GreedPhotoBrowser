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

@implementation GRPhotoBrowserSingleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 1.0;
        [self initView];
        [self setConstraints];
    }
    return self;
}

#pragma mark - public

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(BOOL success))completed {
    [_waitingView setHidden:NO];
    WeakSelf(weakSelf);
    [_imageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
         weakSelf.progress = (CGFloat) receivedSize / expectedSize;
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [_waitingView setHidden:YES];
        if (error) {
            [_failLabel setHidden:NO];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_failLabel setHidden:YES];
            });
            if (completed) {
                completed(NO);
            }
        } else {
            _imageView.image = image;
            if (completed) {
                completed(YES);
            }
        }

    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)updateForScale:(CGFloat)scale animate:(BOOL)animate {
    [_imageViewHeightConstraint setOffset:((scale - 1) * _scrollView.frame.size.height)];
    [_imageViewWidthConstraint setOffset:((scale - 1) * _scrollView.frame.size.width)];

    if (animate) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [_scrollView layoutIfNeeded];
                             [_scrollView setContentOffset:CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2.0, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2.0)];
                         }];
    } else {
        [_scrollView layoutIfNeeded];
        [_scrollView setContentOffset:CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2.0, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2.0)];
    }
}

#pragma mark - getter

- (BOOL)isScaled {
    return 1.0 != _scale;
}

#pragma mark - setter

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    _waitingView.progress = progress;
}

- (void)setScale:(CGFloat)scale {
    [self setScale:scale animate:NO];
}

- (void)setScale:(CGFloat)scale animate:(BOOL)animate {
    if (scale < 0.5 || scale > 2.0 || scale == _scale) {
        return;
    }
    _scale = scale;
    [self updateForScale:scale animate:animate];
}

#pragma mark - action

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer {
    CGFloat scale = recognizer.scale;
    CGFloat temp = _scale + (scale - 1);
    [self setScale:temp];
    recognizer.scale = 1.0;
}

#pragma mark - private

- (void)initView {
    {
        UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scroolView.backgroundColor = GRPhotoBrowserBackgrounColor;
        scroolView.showsHorizontalScrollIndicator = NO;
        scroolView.showsVerticalScrollIndicator = NO;
        [self addSubview:scroolView];
        _scrollView = scroolView;
    }
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
        _imageView = imageView;
    }
    {

        GRPhotoBrowserWaitingView *waitingView = [[GRPhotoBrowserWaitingView alloc] init];
        waitingView.mode = GRPhotoBrowserWaitingViewProgressMode;
        waitingView.hidden = YES;
        [self addSubview:waitingView];
        _waitingView = waitingView;
    }
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"图片加载失败";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.hidden = YES;
        [self addSubview:label];
        _failLabel = label;
       
    }
    // 捏合手势缩放图片
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
    pinch.delegate = self;
    [self addGestureRecognizer:pinch];
}

- (void)setConstraints {
    WeakSelf(weakSelf);
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        _imageViewHeightConstraint = make.height.equalTo(_scrollView);
        _imageViewWidthConstraint = make.width.equalTo(_scrollView);
    }];
    [_waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.width.equalTo(@100);
    }];
    [_failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.equalTo(@30);
        make.width.equalTo(@160);
    }];
}

@end
