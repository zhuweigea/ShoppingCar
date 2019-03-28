//
//  ViewController.m
//  ShoppingCar
//
//  Created by 朱伟阁 on 2019/3/27.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 100, 50);
    btn.center = self.view.center;
    [btn setTitle:@"购物车" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(goShopping) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goShopping{
    ShoppingCarViewController *shoppingcar = [[ShoppingCarViewController alloc]init];
    [self presentViewController:shoppingcar animated:YES completion:nil];
}

@end
