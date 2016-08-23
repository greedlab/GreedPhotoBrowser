# GreedPhotoBrowser

a photo browser for iOS

## [中文README](README-CN.md)

## Installation

```
pod 'GreedPhotoBrowser'
```

## Usage

```objc
    GRPhotoBrowserViewController *viewController = [[GRPhotoBrowserViewController alloc] init];
    viewController.photoItemsArray = _photoItemArray;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
```

## LICENSE

[MIT](LICENSE)
