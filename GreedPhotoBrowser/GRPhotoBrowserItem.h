//
//  GRPhotoBrowserItem.h
//  Pods
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRPhotoBrowserItem : NSObject

/**
 *  缓存显示图
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  本地图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  网络资源
 */
@property (nonatomic, strong) NSURL *url;

@end
