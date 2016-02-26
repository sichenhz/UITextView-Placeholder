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

+ (NSArray *)observingKeys {
    return @[@"bounds", @"font", @"frame", @"text"];
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(label));
    if (label) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    [self swizzledDealloc];
}

- (void)textDidChange:(NSNotification *)notification {
    self.label.hidden = self.text.length;
    if (self.text.length > self.maxLength && self.markedTextRange == nil) {
        self.text = [self.text substringToIndex:self.maxLength];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self layoutLabel];
}

- (void)layoutLabel {
    CGSize rectangleSize = CGSizeMake(self.frame.size.width - kLeftMargin * 2, MAXFLOAT);
    CGSize size = [self.placeholder boundingRectWithSize:rectangleSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                              attributes:@{NSFontAttributeName:self.label.font}
                                                 context:nil].size;
    self.label.frame = CGRectMake(kLeftMargin, kTopMargin, size.width, size.height);
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (self.placeholder != placeholder) {
        objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.label.text = placeholder;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, @selector(placeholder));
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (self.placeholderColor != placeholderColor) {
        objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.label.textColor = placeholderColor;
    }
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, @selector(placeholderColor));
}

- (UILabel *)label {
    UILabel *label = objc_getAssociatedObject(self, @selector(label));
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = self.font ? : [UIFont systemFontOfSize:14];
        label.textColor = self.placeholderColor ? : [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentLeft;
        label.userInteractionEnabled = NO;
        label.numberOfLines = 0;
        [self addSubview:label];
        objc_setAssociatedObject(self, @selector(label), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

- (void)setMaxLength:(NSInteger)maxLength {
    if (self.maxLength != maxLength && maxLength > 0) {
        objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, @selector(maxLength)) integerValue];
}

@end
