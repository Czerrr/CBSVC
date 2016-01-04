//
//  CBTitleButton.h
//  CBScrollViewController
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTitleButton : UIButton
/**
 *  titleButton对应的viewController
 */
@property (nonatomic, strong) UIViewController *viewController;

/**
 *  自定义titleButton的构造方法
 *
 *  @param name           button的title
 *  @param viewController button对应的viewController
 *
 *  @return titleButton对象
 */
+ (instancetype)titleButtonWithName:(NSString *)name viewController:(UIViewController *)viewController;

/** 提供了修改不同state下背景图片的构造方法 */
+ (instancetype)titleButtonWithName:(NSString *)name image:(NSString *)imageName selectedImage:(NSString *)selectedName viewController:(UIViewController *)viewController;
@end
