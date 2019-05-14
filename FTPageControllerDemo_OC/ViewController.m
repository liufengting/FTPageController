//
//  ViewController.m
//  FTPageControllerDemo_OC
//
//  Created by liufengting on 2019/5/13.
//  Copyright © 2019 liufengting. All rights reserved.
//

#import "ViewController.h"
#import "SubViewViewController.h"
#import "FTPageControllerDemo_OC-Swift.h"

@interface ViewController ()

@property (nonatomic, strong) FTPageController *pageController;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.pageController setupWithSuperViewController:self viewControllers:self.viewControllers delegate:nil initialIndex:0 config:nil];
    [self.view addSubview:self.pageController.segment];
    [self.view addSubview:self.pageController.containerView];
}

- (FTPageController *)pageController {
    if (!_pageController) {
        _pageController = [[FTPageController alloc] init];
    }
    return _pageController;
}

- (NSArray<UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = @[[[SubViewViewController alloc] init]];
    }
    return _viewControllers;
}


@end
