//
//  UITextView+Placeholder.m
//  Higo
//
//  Created by sichenwang on 16/2/24.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>

static CGFloat kLeftMargin = 5;
static CGFloat kTopMargin = 8;

@implementation UITextView (Placeholder)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self swizzledDealloc];
}

- (void)textDidChangee:(NSNotification *)notification {
    self.label.hidden = self.text.length;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (self.placeholder != placeholder) {
        objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.label.text = placeholder;
        CGSize rectangleSize = CGSizeMake(self.frame.size.width - kLeftMargin * 2, MAXFLOAT);
        CGSize size = [placeholder boundingRectWithSize:rectangleSize
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                             attributes:@{NSFontAttributeName:self.label.font}
                                                context:nil].size;
        self.label.frame = CGRectMake(kLeftMargin, kTopMargin, size.width, size.height);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangee:) name:UITextViewTextDidChangeNotification object:nil];
    }
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, @selector(placeholder));
}

- (UILabel *)label {
    UILabel *label = objc_getAssociatedObject(self, @selector(label));
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = self.font ? : [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [self addSubview:label];
        objc_setAssociatedObject(self, @selector(label), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

@end
