//
//  YXInputDialog.m
//  YXInputDialogDemo
//
//  Created by Qin Yuxiang on 8/8/16.
//  Copyright © 2016 YuxiangQ. All rights reserved.
//

#import "YXInputDialog.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"

@interface YXInputDialog ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *completionInputButton;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIWindow *containerWindow;
@property (strong, nonatomic) UIView *containerView;

@end

@implementation YXInputDialog

#pragma mark -
#pragma mark Init Methods
- (id)init {
    if (self = [super init]) {
        [self initContainerWindow];
        [self registerUIKeyboardNotification];
        [self initViews];
        [self initTapHideGR];
    }
    return self;
}

- (void)initContainerWindow {
    self.containerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.containerWindow.backgroundColor = [UIColor colorWithRed:0.f
                                                           green:0.f
                                                            blue:0.f
                                                           alpha:.5f];
    self.containerWindow.windowLevel = UIWindowLevelAlert;
    self.containerWindow.hidden = YES;
}

- (void)initViews {
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor colorWithRed:242 / 255.f
                                                         green:245 / 255.f
                                                          blue:245 / 255.f
                                                         alpha:1.f];
    [self.view addSubview:self.containerView];
    
    self.textView = [UITextView new];
    self.textView.placeholder = @"请输入内容";
    self.textView.layer.borderWidth = .5f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.placeholderLabel.font = [UIFont systemFontOfSize:16.f];
    [self.containerView addSubview:self.textView];
    
    
    self.completionInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.completionInputButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.completionInputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completionInputButton setBackgroundColor:[UIColor colorWithRed:12 / 255.f
                                                   green:172 / 255.f
                                                    blue:199 / 255.f
                                                   alpha:1.f]];
    self.completionInputButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.completionInputButton.layer.cornerRadius = 6.f;
    self.completionInputButton.rac_command = [[RACCommand alloc]
                              initWithSignalBlock:^RACSignal *(id input) {
                                  if (self.completionInputBlock) {
                                      self.completionInputBlock();
                                  }
                                  return [RACSignal empty];
                              }];
    [self.containerView addSubview:self.completionInputButton];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19.5f);
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.bottom.mas_equalTo(self.completionInputButton.mas_top).offset(-10.f);
    }];
    
    [self.completionInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.bottom.mas_equalTo(-20.f);
        make.width.mas_equalTo(70.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(160.f);
    }];

}

- (void)initTapHideGR {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]
                                     initWithTarget:nil
                                     action:nil];
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        [self hideDialog];
    }];
    tapGR.delegate = self;
    [self.view addGestureRecognizer:tapGR];
}

#pragma mark -
#pragma mark UIViewController Methods
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.containerWindow = nil;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.containerView) {
        return NO;
    }
    return YES;
}

- (void)registerUIKeyboardNotification {
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardWillShowNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
         [UIView animateWithDuration:1.f
                          animations:^{
                              [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                                  make.bottom.mas_equalTo(-keyboardHeight);
                              }];
                          }];
         [self.view layoutIfNeeded];
     }];
    
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:UIKeyboardDidHideNotification
      object:nil]
     subscribeNext:^(NSNotification *notification) {
         [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.bottom.mas_equalTo(0.f);
         }];
     }];

}


- (void)showDialog {
    self.containerWindow.hidden = NO;
    [self.containerWindow addSubview:self.view];
}

- (void)hideDialog {
    [self.textView resignFirstResponder];
    [self.view removeFromSuperview];
    self.containerWindow.hidden = YES;

}

@end
