//
//  GrPhotoBrowserConfig.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#ifndef GrPhotoBrowserConfig_h
#define GrPhotoBrowserConfig_h

typedef enum {
    GRPhotoBrowserWaitingViewModeLoopDiagram, // 环形
    GRPhotoBrowserWaitingViewModePieDiagram // 饼型
} GRPhotoBrowserWaitingViewMode;

#ifndef WeakSelf
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#endif

// 图片保存成功提示文字
#define GRPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 "

// 图片保存失败提示文字
#define GRPhotoBrowserSaveImageFailText @" >_< 保存失败 "

// browser背景颜色
#define GRPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define GRPhotoBrowserSingleViewMargin 10

// browser中显示图片动画时长
#define GRPhotoBrowserShowImageAnimationDuration 0.3

// browser中显示图片动画时长
#define GRPhotoBrowserHideImageAnimationDuration 0.3

// 图片下载进度指示进度显示样式（GRPhotoBrowserWaitingViewModeLoopDiagram 环形，GRPhotoBrowserWaitingViewModePieDiagram 饼型）
#define GRPhotoBrowserWaitingViewProgressMode GRPhotoBrowserWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define GRPhotoBrowserWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define GRPhotoBrowserWaitingViewItemMargin 10

#endif /* GrPhotoBrowserConfig_h */
