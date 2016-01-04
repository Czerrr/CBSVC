//
//  CBFourViewController.m
//  CBDemo
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import "CBFourViewController.h"

@interface CBFourViewController ()

@end

@implementation CBFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"FourViewController";
    
    return cell;
}

@end
