//
//  ViewController.m
//  8月20日转盘
//
//  Created by 李景浩 on 16/8/20.
//  Copyright © 2016年 李大米. All rights reserved.
//

#import "ViewController.h"
#import "Wheel.h"

@interface ViewController ()

@property(nonatomic,weak)Wheel *wheel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    添加进去
    Wheel *wheel = [Wheel wheel];
    wheel.center = self.view.center;
    
//    不要丢下这一步！！！
    self.wheel = wheel;
    
    [self.view addSubview:wheel];
    
    
}
/**
 *  实现开始和暂停的方法
 */
- (IBAction)start:(id)sender {
    
    [self.wheel start];
}
- (IBAction)end:(id)sender {
    [self.wheel end];
    
}

@end
