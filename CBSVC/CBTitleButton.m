//
//  CBTitleButton.m
//  CBScrollViewController
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import "CBTitleButton.h"
#import "UIView+CBFrameExtension.h"

@implementation CBTitleButton
+ (instancetype)titleButtonWithName:(NSString *)name viewController:(UIViewController *)viewController {
    return [self titleButtonWithName:name image:@"compose_emotion_table_right_normal" selectedImage:@"compose_emotion_table_right_selected" viewController:viewController];
}

+ (instancetype)titleButtonWithName:(NSString *)name image:(NSString *)imageName selectedImage:(NSString *)selectedName viewController:(UIViewController *)viewController {
    CBTitleButton *titleButton = [[self alloc] init];
    titleButton.viewController = viewController;
    
    // 初始化button
    titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [titleButton setTitle:[NSString stringWithFormat:@"%@", name] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [titleButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [titleButton setBackgroundImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    
    return  titleButton;
}
@end
