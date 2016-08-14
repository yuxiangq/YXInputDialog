//
//  YXInputDialog.h
//  YXInputDialogDemo
//
//  Created by Qin Yuxiang on 8/8/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Placeholder.h"

typedef void(^CompletionInputBlock)();
@interface YXInputDialog : UIViewController

@property (strong, nonatomic, readonly) UIButton *completionInputButton;
@property (strong, nonatomic, readonly) UITextView *textView;
@property (copy, nonatomic) CompletionInputBlock completionInputBlock;

- (void)showDialog;
- (void)hideDialog;

@end
