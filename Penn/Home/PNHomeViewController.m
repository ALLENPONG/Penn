//
//  PNHomeViewController.m
//  Penn
//
//  Created by PENN on 2017/9/9.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNHomeViewController.h"
#import "PNSocketController.h"
#import "PNKitViewController.h"
#import "PNFundationController.h"
#import "Penn-Swift.h"

static NSString * const reuseCellId = @"HomeCell";

@interface PNHomeViewController ()

@end

@implementation PNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    [self setupUI];
    [self.dataSource addObjectsFromArray:@[
                                           @"PNKitViewController",
                                           @"PNSocketController",
                                           @"PNFundationController"
                                           ]];

    UIButton * button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 88, 300, 500);
    [button setTitle:@"title" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - TableView Delegate/DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * clsName = self.dataSource[indexPath.row];
    BaseViewController * vc = [[NSClassFromString(clsName) alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Action

- (void)nextSwift{
    
    PNSwiftViewController * swift = [[PNSwiftViewController alloc] init];
    [self.navigationController pushViewController:swift animated:YES];
}

#pragma mark - Private Methods

- (void)setupUI{
    [super setupUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellId];
    
    //下一级:swift
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bottomNav-forwardEngaged"] style:UIBarButtonItemStylePlain target:self action:@selector(nextSwift)];
    self.navigationItem.rightBarButtonItem = right;
    //左边按钮
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"试试" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = left;
    

    
}



@end
