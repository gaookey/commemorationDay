//
//  UIFont+GWLAdjustFont.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/5.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "UIFont+GWLAdjustFont.h"
#import <objc/runtime.h>

@implementation UIFont (GWLAdjustFont)

+ (void)load {
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width / 375];
    return newFont;
}

@end
