//
//  ViewController.m
//  YXInputDialogDemo
//
//  Created by Qin Yuxiang on 8/8/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import "ViewController.h"
#import "YXInputDialog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *showDialogButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 44)];
    [showDialogButton setTitle:@"显示对话框"
                      forState:UIControlStateNormal];
    [showDialogButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showDialogButton addTarget:self
                         action:@selector(showDialog)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showDialogButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDialog {
    YXInputDialog *dialog = [YXInputDialog new];
    dialog.textView.placeholder = @"请输入您要发送的内容";
    [dialog.completionInputButton setTitle:@"发送"
                                  forState:UIControlStateNormal];
    dialog.completionInputBlock = ^{
        
    };
    [dialog showDialog];
}

@end
