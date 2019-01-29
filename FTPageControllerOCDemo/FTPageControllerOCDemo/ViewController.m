//
//  ViewController.m
//  FTPageControllerOCDemo
//
//  Created by liufengting on 2019/1/29.
//  Copyright © 2019 liufengting. All rights reserved.
//

#import "ViewController.h"
#import <FTPageController/FTPageController-Swift.h>

@interface ViewController () <FTPageControllerDelegate>

@property (nonatomic, strong) FTPageController *pageController;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
    
    [self.pageController setupWithSuperViewController:self viewControllers:self.viewControllers delegate:self initialIndex:0 config:nil];
    [self.view addSubview:self.pageController.segement];
    [self.view addSubview:self.pageController.scrollView];
}

- (FTPageController *)pageController {
    if (!_pageController) {
        _pageController = [[FTPageController alloc] init];
    }
    return _pageController;
}

- (NSArray<UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = @[[[UIViewController alloc] init], [[UIViewController alloc] init], [[UIViewController alloc] init], [[UIViewController alloc] init], [[UIViewController alloc] init], [[UIViewController alloc] init]];
    }
    return _viewControllers;
}




@end
