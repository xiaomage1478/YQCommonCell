//
//  YQCommonViewController.m
//  YQCommonCell
//
//  Created by easylink on 2017/12/8.
//  Copyright © 2017年 YuQi. All rights reserved.
//

#import "YQCommonViewController.h"
#import "YQCommonCell.h"
#import "YQCommonGroup.h"
#import "YQCommonItem.h"

@interface YQCommonViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation YQCommonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.commonTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.commonTableView.dataSource = self;
    self.commonTableView.delegate = self;
    self.commonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.commonTableView];
    
    
    CGFloat StatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat NavBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tableViewY;
    if (self.navigationController && self.navigationController.navigationBar.hidden == NO) {
        tableViewY = StatusBarHeight + NavBarHeight;
    } else {
        tableViewY = StatusBarHeight;
    }
    
    self.commonTableView.frame = CGRectMake(0, tableViewY, self.view.bounds.size.width, self.view.bounds.size.height - tableViewY);
    if (@available(iOS 11.0, *)) {
        self.commonTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - public


#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQCommonGroup *group = self.commonGroups[indexPath.section];
    YQCommonItem *item = group.items[indexPath.row];
    return item.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commonGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQCommonGroup *group = self.commonGroups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQCommonCell *cell = [YQCommonCell cellWithTableView:tableView];
    YQCommonGroup *group = self.commonGroups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQCommonGroup *group = self.commonGroups[indexPath.section];
    YQCommonItem *item = group.items[indexPath.row];
    
    if (item.destVcClass) {
        [self presentViewController:[[item.destVcClass alloc] init] animated:YES completion:nil];
    }
    
    if (item.operation) {
        item.operation();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    YQCommonGroup *group = self.commonGroups[section];
    return group.headerView ? group.headerView.bounds.size.height : group.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    YQCommonGroup *group = self.commonGroups[section];
    return group.footerView ? group.footerView.bounds.size.height : group.footerHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YQCommonGroup *group = self.commonGroups[section];
    return group.headerView ? group.headerView : [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    YQCommonGroup *group = self.commonGroups[section];
    return group.footerView ? group.footerView : [[UIView alloc] init];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSMutableArray *)commonGroups
{
    if (!_commonGroups) {
        _commonGroups = [NSMutableArray array];
    }
    return _commonGroups;
}
@end
