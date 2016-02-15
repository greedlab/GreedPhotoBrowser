//
//  GRPhotoBrowserView.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPhotoBrowserItem.h"

@class GRPhotoBrowserView;

@protocol GRPhotoBrowserViewDataSource <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(GRPhotoBrowserView *)photoBrowser;
- (GRPhotoBrowserItem *)photoBrowser:(GRPhotoBrowserView *)photoBrowser photoAtIndex:(NSUInteger)index;

@end

@protocol GRPhotoBrowserViewDelegate <NSObject>

- (void)didDismissInPhotoBrowser:(GRPhotoBrowserView *)photoBrowser;

@end

@interface GRPhotoBrowserView : UIView<UIScrollViewDelegate>
{
    BOOL _hasShowedFistView;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *saveBgView;
@property (nonatomic, strong) UILabel *saveLabel;

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<GRPhotoBrowserViewDataSource> dataSource;
@property (nonatomic, weak) id<GRPhotoBrowserViewDelegate> delegate;

- (void)show;
- (void)reload;

@end
