//
//  UITextField+placeholderColor.m
//  runtime机制
//
//  Created by  jason on 15/12/23.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "UITextField+placeholderColor.h"
#import <objc/runtime.h>


@implementation UITextField (placeholderColor)
static char placeholderColorName;
- (void)setPlaceholderColor:(UIColor *)placeholderColor {

    // 设置关联
    objc_setAssociatedObject(self, &placeholderColorName , placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 设置颜色
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
    
    
    
}

- (UIColor*)placeholderColor {

    // 返回
    return objc_getAssociatedObject(self, &placeholderColorName);
}
@end
