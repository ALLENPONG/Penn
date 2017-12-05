//
//  PNKeyboardController.m
//  Penn
//
//  Created by SanRong on 2017/12/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKeyboardController.h"

@interface PNKeyboardController ()<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITextView *tv1;
@property (weak, nonatomic) IBOutlet UITextView *tv2;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomCons;

@end

@implementation PNKeyboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //0. 设置代理
    self.tv1.delegate = self;
    //self.tv2.delegate = self;
    self.tf.delegate = self;

    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - Private Methods

- (void)KeyboardWillChangeFrame:(NSNotification *)notify{
    //1. 获取键盘rect
    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //2. 更改toolbar的底部约束常量, 为负值
    self.toolBarBottomCons.constant = -self.view.bounds.size.height + rect.origin.y;
    //3. 动画效果
    double durTime = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:durTime animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
/**
    为textfield添加辅助视图inputAccessoryView, 并且切换inputView
 */
- (void)changeKeyboard{
    //必须通过通知才能准确实时获取键盘高度, 此处是271
    //1. 创建新视图,指定高度即可
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 271)];
    view.backgroundColor = [UIColor orangeColor];
    //2. 设置视图
    self.tf.inputView = view;
    //3. 刷新视图
    [self.tf reloadInputViews];
    //4. option: 设置辅助视图
    //不能直接使用self.toolbar, 辅助视图不能有父视图
    UIToolbar * tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    tb.backgroundColor = [UIColor blueColor];
    self.tf.inputAccessoryView = tb;

}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
   
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self changeKeyboard];
}


@end
