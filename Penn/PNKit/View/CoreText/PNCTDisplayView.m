//
//  PNCTDisplayView.m
//  Penn
//
//  Created by emoji on 2018/7/27.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCTDisplayView.h"
#import <CoreText/CoreText.h>
#import "PNCTImageData.h"

@implementation PNCTDisplayView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEvents];
    }
    return self;
}

/**
 添加事件
 */
- (void)setupEvents{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    for (PNCTImageData * imgData in self.data.imageArray) {
        // 翻转坐标系.因为imageData中的坐标是CoreText中的坐标系
        CGRect imageRect = imgData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击的位置是否在rect之内
        if(CGRectContainsPoint(rect, point)){
            NSDictionary *userInfo = @{@"imageData": imgData};
            //发送点击通知
            [[NSNotificationCenter defaultCenter] postNotificationName:PNCTDisplayViewImageTapedNOtification
                                                                object:self
                                                              userInfo:userInfo];
            break;
        }
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!self.data) {
        return;
    }
    //1. 获取绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2. 坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //3. 创建绘制区域
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    //设置不同的文字绘制区域
    //    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    //4.
//    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:@"Hello TextCore"];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, NULL);
    
    //5.
//    CTFrameDraw(frame, context);

    CTFrameDraw(self.data.ctFrame, context);
    
    for (PNCTImageData *imgData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imgData.name];
        if (image) {
            CGContextDrawImage(context, imgData.imagePosition, image.CGImage);
        }
    }
    //6.
//    CFRelease(frame);
//    CFRelease(path);
//    CFRelease(framesetter);
    
}


@end
