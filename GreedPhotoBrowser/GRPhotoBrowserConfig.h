//
//  GRPhotoBrowserConfig.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#ifndef GRPhotoBrowserConfig_h
#define GRPhotoBrowserConfig_h

typedef enum : NSUInteger {
    GRPhotoBrowserWaitingViewModeLoopDiagram = 1, // 环形
    GRPhotoBrowserWaitingViewModePieDiagram   // 饼型
} GRPhotoBrowserWaitingViewMode;

#ifndef WeakSelf
#define WeakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self;
#endif

// 图片保存成功提示文字
#ifndef GRPhotoBrowserSaveImageSuccessText
#define GRPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 "
#endif

// 图片保存失败提示文字
#ifndef GRPhotoBrowserSaveImageFailText
#define GRPhotoBrowserSaveImageFailText @" >_< 保存失败 "
#endif

// browser背景颜色
#ifndef GRPhotoBrowserBackgrounColor
#define GRPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]
#endif

// browser中图片间的margin
#ifndef GRPhotoBrowserSingleViewMargin
#define GRPhotoBrowserSingleViewMargin 10
#endif

// 图片下载进度指示进度显示样式（GRPhotoBrowserWaitingViewModeLoopDiagram 环形，GRPhotoBrowserWaitingViewModePieDiagram 饼型）
#ifndef GRPhotoBrowserWaitingViewProgressMode
#define GRPhotoBrowserWaitingViewProgressMode GRPhotoBrowserWaitingViewModeLoopDiagram
#endif

// 图片下载进度指示器背景色
#ifndef GRPhotoBrowserWaitingViewBackgroundColor
#define GRPhotoBrowserWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#endif

// 图片下载进度指示器内部控件间的间距
#ifndef GRPhotoBrowserWaitingViewItemMargin
#define GRPhotoBrowserWaitingViewItemMargin 10
#endif

#endif /* GRPhotoBrowserConfig_h */
