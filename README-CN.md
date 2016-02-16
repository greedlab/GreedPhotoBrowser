# GreedPhotoBrowser

iOS图片浏览器

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

## 更新记录

[CHANGELOG](CHANGELOG.md)

## LICENSE

[MIT](LICENSE)
