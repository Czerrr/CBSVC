//
//  CBTwoViewController.m
//  CBDemo
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import "CBTwoViewController.h"

@interface CBTwoViewController ()

@end

@implementation CBTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"TwoViewController";
    
    return cell;
}

@end
