//
//  ViewController.m
//  Example
//
//  Created by Bell on 16/2/15.
//  Copyright © 2016年 GreedLab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/w%3D2048/sign=bf43f947be315c6043956cefb989ca13/c83d70cf3bc79f3da761b162b8a1cd11738b29db.jpg"];
    NSURL *url1 = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/w%3D2048/sign=bf43f947be315c6043956cefb989ca13/c83d70cf3bc79f3da761b1"];
    _srcStringArray = @[ [UIImage imageNamed:@"qq"],
                         [UIImage imageNamed:@"pengyouquan"],
                         [UIImage imageNamed:@"qq"],
                         [UIImage imageNamed:@"pengyouquan"],
                         [UIImage imageNamed:@"qq"],
                         [UIImage imageNamed:@"pengyouquan"],
                         url1,
                         [UIImage imageNamed:@"pengyouquan"],
                         url ];
    NSMutableArray *temp = [NSMutableArray array];
    [_srcStringArray enumerateObjectsUsingBlock:^(NSObject *src, NSUInteger idx, BOOL *stop) {
        GRPhotoBrowserItem *item = [[GRPhotoBrowserItem alloc] init];
        if ([src isKindOfClass:[UIImage class]]) {
            item.image = (UIImage *) src;
            item.placeholderImage = nil;
            [temp addObject:item];
        } else if ([src isKindOfClass:[NSURL class]]) {
            item.url = (NSURL *) src;
            item.placeholderImage = [UIImage imageNamed:@"pengyouquan"];
            [temp addObject:item];
        }
    }];
    _photoItemArray = temp;

    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.frame = CGRectMake(200, 200, 100, 50);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
    GRPhotoBrowserViewController *viewController = [[GRPhotoBrowserViewController alloc] init];
    viewController.photoItemsArray = _photoItemArray;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    viewController.currentIndex = 2;
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
