# GreedPhotoBrowser

iOS图片浏览器

[English](README.md) | 中文)

## 安装

```
pod 'GreedPhotoBrowser'
```

## 使用说明

```objc
     GRPhotoBrowserViewController *viewController = [[GRPhotoBrowserViewController alloc] init];
    viewController.photoItemsArray = _photoItemArray;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
```
