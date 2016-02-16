//
//  GRPhotoBrowserViewController.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPhotoBrowserView.h"

@interface GRPhotoBrowserViewController : UIViewController
<GRPhotoBrowserViewDelegate
,GRPhotoBrowserViewDataSource>

@property (nonatomic, strong) GRPhotoBrowserView *photoBrowser;

@property (nonatomic, strong) NSArray *photoItemsArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end
