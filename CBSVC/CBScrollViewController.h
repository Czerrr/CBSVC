//
//  CBScrollViewController.h
//  CBScrollViewController
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBScrollViewController : UIViewController
/**
 *  提供给外界调用的构造方法
 *
 *  @param titleButtonArray 装有CBTitleButton的数组
 *
 *  @return CBScrollViewController
 */
+ (instancetype)scrollViewControllerWithTitleButtonArray:(NSArray *)titleButtonArray;
@end
