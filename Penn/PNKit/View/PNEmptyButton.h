//
//  PNEmptyButton.h
//  Penn
//
//  Created by gjb on 2018/5/7.
//  Copyright © 2018年 SanRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNEmptyButton : UIControl

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

+ (PNEmptyButton *)emptyButton;

@end
