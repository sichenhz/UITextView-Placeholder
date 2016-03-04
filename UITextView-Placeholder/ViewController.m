//
//  ViewController.m
//  UITextView-Placeholder
//
//  Created by sichenwang on 16/2/24.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Placeholder.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableParagraphStyle *styleM = [[NSMutableParagraphStyle alloc] init];
    styleM.lineSpacing = 10;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu"];
    [attrStrM addAttribute:NSParagraphStyleAttributeName value:styleM range:NSMakeRange(0, attrStrM.length)];

    self.textView2.attributedPlaceholder = [attrStrM copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
