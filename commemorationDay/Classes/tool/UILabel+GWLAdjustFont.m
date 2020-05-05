//
//  UILabel+GWLAdjustFont.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/5.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "UILabel+GWLAdjustFont.h"
#import <objc/runtime.h>

@implementation UILabel (GWLAdjustFont)

+ (void)load {
    Method newMethod = class_getInstanceMethod([UILabel class], @selector(gwl_awakeFromNib));
    Method method = class_getInstanceMethod([UILabel class], @selector(awakeFromNib));
    if (!class_addMethod([UILabel class], @selector(awakeFromNib), method_getImplementation(newMethod), method_getTypeEncoding(method))) {
        method_exchangeImplementations(method, newMethod);
    } else {
        class_replaceMethod(self, @selector(gwl_awakeFromNib), method_getImplementation(method), method_getTypeEncoding(method));
    }
}
- (void)gwl_awakeFromNib {
    [self gwl_awakeFromNib];
    self.font = [UIFont fontWithDescriptor:self.font.fontDescriptor size:self.font.pointSize * [UIScreen mainScreen].bounds.size.width / 414];
}

@end
