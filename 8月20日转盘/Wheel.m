//
//  Wheel.m
//  8月20日转盘
//
//  Created by 李景浩 on 16/8/20.
//  Copyright © 2016年 李大米. All rights reserved.
//

#import "Wheel.h"
#import "WheelBtn.h"

@interface Wheel()

@property (weak, nonatomic) IBOutlet UIImageView *backView;

@property(nonatomic,weak)UIButton *preBtn;

@property(strong,nonatomic)CADisplayLink *link;

@end


@implementation Wheel
/**
 *  懒加载link
 */
-(CADisplayLink *)link{

    if (_link == nil) {
        
        CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginRotation)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link = link;
    }
    return _link;
}
/**
 *  实现CADisplayLink中的方法。是指旋转
 */
-(void)beginRotation{

    self.backView.transform = CGAffineTransformRotate(self.backView.transform, M_PI / 200.0);
}

+(instancetype)wheel{

    return [[[NSBundle mainBundle]loadNibNamed:@"Wheel" owner:nil options:nil]lastObject];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"Wheel" owner:nil options:nil][0];
        [self addImage];
    }
    return self;
}

-(void)awakeFromNib{

    [self addImage];
}

-(void)start{

    self.link.paused = NO;
    
}
-(void)end{

    self.link.paused = YES;
    
}

- (IBAction)startChooseBtn:(id)sender {

    self.link.paused = YES;

//    开始执行动画，快速的旋转
    CABasicAnimation *cba = [CABasicAnimation animation];
    cba.keyPath = @"transform.rotation";
    cba.toValue = @(M_PI * 3);
    cba.duration = 1;
//    用代理，核心动画结束时调用一个代理方法
    cba.delegate = self;
    
    [self.backView.layer addAnimation:cba forKey:nil];
}
/**
 *  实现代理方法
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

//    获取当前点击按钮的旋转角度
    CGAffineTransform transform = self.preBtn.transform;
//    这里atan2(y,x),表示坐标系，正好获取角度
    CGFloat angel = atan2(transform.b, transform.a);
//    让背景View倒着回去
    self.backView.transform = CGAffineTransformMakeRotation(-angel);
    
//    延迟之后再继续旋转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.link.paused = NO;
    });
}


/**
 *  在每一圈的每一格上添加图片
 */
-(void)addImage{

//    设置背景View为可交互
    self.backView.userInteractionEnabled = YES;
    
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    CGFloat angle = 0;
    
//    给每一格添加图片
    UIImage *orignImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *pressImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
//    为了显示与屏幕一样的分辨率，获取屏幕的宽高比
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat clipW = orignImage.size.width / 12 * scale;
    CGFloat clipH = orignImage.size.height * scale;
    CGFloat clipX = 0;
    CGFloat clipY = 0;
    
    
    for (int i = 0; i < 12; i++) {
        WheelBtn *btn = [WheelBtn buttonWithType:UIButtonTypeCustom];
        
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
//        让每个按钮进行旋转
        btn.transform = CGAffineTransformMakeRotation(angle / 180 * M_PI);
        angle +=30;
        
//        给按钮添加点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        给每一格的按钮添加图片，先进行裁剪
        clipX = i * clipW;
        CGRect rect = CGRectMake(clipX, clipY, clipW, clipH);
//        裁剪原始图片
        CGImageRef refImage = CGImageCreateWithImageInRect(orignImage.CGImage, rect);
        UIImage *NewImage = [UIImage imageWithCGImage:refImage];
        [btn setImage:NewImage forState:UIControlStateNormal];
//        裁剪高亮状态的图片
        CGImageRef hightImage = CGImageCreateWithImageInRect(pressImage.CGImage, rect);
        UIImage *preIma = [UIImage imageWithCGImage:hightImage];
        [btn setImage:preIma forState:UIControlStateSelected];
        
//        给按钮添加选中时的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
//添加到背景View中
        [self.backView addSubview:btn];
        
//        初始使默认第一个为选中
        if (i == 0) {
            [self btnClick:btn];
        }
        
    }
}

-(void)btnClick:(UIButton *)btn{
//只能选中一个，把上一个设为NO
    self.preBtn.selected = NO;
//    当前的按钮设为YES
    btn.selected = YES;
//    再把当前的按钮复制个上一个
    self.preBtn = btn;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
