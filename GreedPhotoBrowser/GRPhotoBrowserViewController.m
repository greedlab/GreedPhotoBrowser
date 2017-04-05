//
//  GRPhotoBrowserViewController.m
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import "GRPhotoBrowserViewController.h"
#import "GRPhotoBrowserConfig.h"
#import "Masonry.h"

@implementation GRPhotoBrowserViewController

#pragma mark - getter

- (GRPhotoBrowserView *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[GRPhotoBrowserView alloc] initWithFrame:self.view.bounds];
        _photoBrowser.delegate = self;
        _photoBrowser.dataSource = self;
        _photoBrowser.currentIndex = _currentIndex;
    }
    return _photoBrowser;
}

#pragma mark - setter

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _photoBrowser.currentIndex = _currentIndex;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoBrowser];
    [self setConstraint];

    [self.photoBrowser show];
}

#pragma mark - GRPhotoBrowserViewDataSource

- (NSUInteger)numberOfPhotosInPhotoBrowser:(GRPhotoBrowserView *)photoBrowser {
    return _photoItemsArray.count;
}

- (GRPhotoBrowserItem *)photoBrowser:(GRPhotoBrowserView *)photoBrowser
                        photoAtIndex:(NSUInteger)index {
    return _photoItemsArray[index];
}

#pragma mark - GRPhotoBrowserViewDelegate

- (void)didDismissInPhotoBrowser:(GRPhotoBrowserView *)photoBrowser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)setConstraint {
    WeakSelf(weakSelf);
    [_photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

@end
