//
//  WheelBtn.m
//  8月20日转盘
//
//  Created by 李景浩 on 16/8/20.
//  Copyright © 2016年 李大米. All rights reserved.
//

#import "WheelBtn.h"

@implementation WheelBtn

/**
 *  返回按钮当中UIImageView的尺寸大小位置
 *
 *  @param contentRect 当前按钮的尺寸
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    CGFloat w = 40;
    CGFloat h = 50;
    CGFloat x = (contentRect.size.width - w) * 0.5;
    CGFloat y = 20;
    
    return CGRectMake(x, y, w, h);

}

/**
 *  设置图片的上半部分能点击，下半部分不能点击
 */
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;
    
    CGFloat X = 0;
    CGFloat W = btnW;
    CGFloat H = btnH * 0.4;
    CGFloat Y = H;
    
    CGRect rect = CGRectMake(X, Y, W, H);
    if (CGRectContainsPoint(rect, point)) {
        return nil;
    }else{
    
        return [super hitTest:point withEvent:event];
    }
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
