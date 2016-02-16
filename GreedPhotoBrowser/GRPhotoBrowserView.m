//
//  GRPhotoBrowserView.m
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import "GRPhotoBrowserView.h"
#import "UIImageView+WebCache.h"
#import "GRPhotoBrowserSingleView.h"
#import "Masonry.h"
#import "GRPhotoBrowserConfig.h"

@implementation GRPhotoBrowserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showed = NO;
        _viewHeight = 0.f;
        _viewWidth = 0.f;
        [self initView];
        [self setConstraint];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL viewWidthOrHeightUpdated = NO;
    CGFloat newWidth = CGRectGetWidth(self.frame);
    if (_viewWidth != newWidth) {
        _viewWidth = newWidth;
        viewWidthOrHeightUpdated = YES;
    }
    CGFloat newHeight = CGRectGetHeight(self.frame);
    if (_viewHeight != newHeight) {
        _viewHeight = newHeight;
        viewWidthOrHeightUpdated = YES;
    }
    
    if (viewWidthOrHeightUpdated) {
        [self viewWidthOrHeightUpdated];
    }
}

#pragma mark - public

- (void)show
{
    self.imageCount = [self.dataSource numberOfPhotosInPhotoBrowser:self];
    [self updateIndexLabel];
    [self updateScrollView];
    [self updateScrollViewContentOffsetWithAnimated:NO];
    [self setupImageOfImageViewForIndex:_currentIndex];
    _showed = YES;
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        label.layer.cornerRadius = 15;
        label.layer.masksToBounds = YES;
        _indexLabel = label;
    }
    return _indexLabel;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _saveButton = button;
    }
    return _saveButton;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.hidden = YES;
        _indicatorView = indicator;
    }
    return _indicatorView;
}

- (UIView *)saveBgView {
    if (_saveBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.hidden = YES;
        _saveBgView = view;
    }
    return _saveBgView;
}

- (UILabel *)saveLabel {
    if (!_saveLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.hidden = YES;
        _saveLabel = label;
    }
    return _saveLabel;
}

#pragma mark - setter

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) {
        return;
    }
    if (currentIndex >= [self.dataSource numberOfPhotosInPhotoBrowser:self]) {
        return;
    }
    _currentIndex = currentIndex;
    if (_showed) {
        [self updateIndexLabel];
        [self setupImageOfImageViewForIndex:_currentIndex];
        [self updateScrollViewContentOffsetWithAnimated:YES];
    }
}

#pragma mark - action

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    [_indicatorView setHidden:NO];
    [_indicatorView startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView stopAnimating];
    [_indicatorView setHidden:YES];
    
    _saveLabel.text = error ? GRPhotoBrowserSaveImageFailText : GRPhotoBrowserSaveImageSuccessText;
    [_saveLabel setHidden:NO];
    [_saveBgView setHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_saveBgView setHidden:YES];
        [_saveLabel setHidden:YES];
    });
}

/**
 *  加载图片
 */
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    NSArray *array = [_scrollView subviews];
    if (index >= array.count) {
        return;
    }
    GRPhotoBrowserSingleView *singleView = array[index];
    if (singleView.hasLoadedImage) {
        [_saveButton setHidden:NO];
        return;
    }
    if([self highQualityImageForIndex:index]){
        [singleView.imageView setImage:[self highQualityImageForIndex:index]];
        [_saveButton setHidden:NO];
    } else if ([self highQualityImageURLForIndex:index]) {
        [_saveButton setHidden:YES];
        [singleView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index] completed:^(BOOL success) {
            [_saveButton setHidden:!success];
        }];
    } else {
        singleView.imageView.image = [self placeholderImageForIndex:index];
        [_saveButton setHidden:NO];
    }
    singleView.hasLoadedImage = YES;
}

/**
 *  单击消失
 */
- (void)imageViewSingleTaped:(UITapGestureRecognizer *)recognizer
{
    [self.delegate didDismissInPhotoBrowser:self];
}

/**
 *  双击放大，更改scale可以改放大倍数
 */
- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    GRPhotoBrowserSingleView *imageView = (GRPhotoBrowserSingleView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 1.5;
    }
    [imageView setScale:scale animate:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        return;
    }
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        GRPhotoBrowserSingleView *singleView = _scrollView.subviews[index];
        if (singleView.isScaled) {
            [singleView setScale:1.0 animate:YES];
        }
    }
    self.currentIndex = index;
}

#pragma mark - private

- (void)initView
{
    self.backgroundColor = GRPhotoBrowserBackgrounColor;
    
    [self addSubview:self.scrollView];
    [self addSubview:self.indexLabel];
    [self addSubview:self.saveButton];
    [self addSubview:self.indicatorView];
    [self addSubview:self.saveBgView];
    [self addSubview:self.saveLabel];
}

- (void)setConstraint
{
    WeakSelf(weakSelf);
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(20.0);
        make.width.mas_equalTo(80.0);
        make.height.mas_equalTo(30.0);
        make.centerX.equalTo(weakSelf);
    }];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.bottom.equalTo(weakSelf).offset(-20);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    [_saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    [_saveBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_saveLabel).insets(UIEdgeInsetsMake(-10, -10, -10, -10));
    }];
}

- (void)updateIndexLabel
{
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentIndex + 1, (long)_imageCount];
}

-(void)updateScrollView
{
    for (UIView *view in [_scrollView subviews]) {
        [view removeFromSuperview];
    }
    if (_imageCount <= 0 ) {
        return;
    }
    for (int i = 0; i < _imageCount; i ++) {
        GRPhotoBrowserSingleView *imageView = [[GRPhotoBrowserSingleView alloc] init];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTaped:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    NSArray *array = [_scrollView subviews];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.width.height.equalTo(_scrollView);
        }];
        if (idx == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(_scrollView);
            }];
            if (idx == array.count - 1) {
                [view mas_makeConstraints:^(MASConstraintMaker *make){
                    make.right.equalTo(_scrollView);
                }];
            }
        } else if (idx == array.count - 1) {
            UIView *preView = [array objectAtIndex:(idx - 1)];
            [view mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(preView.mas_right);
                make.right.equalTo(_scrollView);
            }];
        } else {
            UIView *preView = [array objectAtIndex:(idx - 1)];
            [view mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(preView.mas_right);
            }];
        }
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    GRPhotoBrowserItem *photo = [self.dataSource photoBrowser:self photoAtIndex:index];
    return photo.placeholderImage;
}

- (UIImage *)highQualityImageForIndex:(NSInteger)index
{
    GRPhotoBrowserItem *photo = [self.dataSource photoBrowser:self photoAtIndex:index];
    return photo.image;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    GRPhotoBrowserItem *photo = [self.dataSource photoBrowser:self photoAtIndex:index];
    return photo.url;
}

- (void)viewWidthOrHeightUpdated {
    {
        [self updateScrollViewContentOffsetWithAnimated:YES];
    }
    {
        GRPhotoBrowserSingleView *singleView = [_scrollView subviews][_currentIndex];
        [singleView updateForScale:singleView.scale animate:YES];
    }
}

- (void)updateScrollViewContentOffsetWithAnimated:(BOOL)animated {
    CGPoint offset = _scrollView.contentOffset;
    CGFloat newX = _currentIndex * _scrollView.frame.size.width;
    if (newX != offset.x) {
        offset.x = newX;
        [_scrollView setContentOffset:offset animated:animated];
    }
}

@end
