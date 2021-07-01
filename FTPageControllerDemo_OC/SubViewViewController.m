//
//  SubViewViewController.m
//  FTPageControllerDemo_OC
//
//  Created by liufengting on 2019/5/13.
//  Copyright © 2019 liufengting. All rights reserved.
//

#import "SubViewViewController.h"

static NSString * const SubCellsIndentifier = @"SubCellsIndentifier";

@interface SubViewViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:SubCellsIndentifier];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCellsIndentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Title %ld", self.vcIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
