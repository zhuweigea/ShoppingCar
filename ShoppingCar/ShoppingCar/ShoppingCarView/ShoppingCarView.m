//
//  ShoppingCarView.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ShoppingCarView.h"

@implementation ShoppingCarView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.selectALLBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectALLBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectALLBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
        [self.selectALLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selectALLBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.selectALLBtn addTarget:self action:@selector(selectAllGoods) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectALLBtn];
    
        self.totalPrice = [[UILabel alloc]init];
        self.totalPrice.textColor = [UIColor blackColor];
        self.totalPrice.text = @"总价：";
        [self addSubview:self.totalPrice];
        
        self.calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.calculateBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.calculateBtn.backgroundColor = [UIColor orangeColor];
        [self.calculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.calculateBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf;
    [self.selectALLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(80);
    }];
    [self.calculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(weakSelf);
    }];
    [self.totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.selectALLBtn.mas_right).offset(20);
    }];
}

- (void)selectAllGoods{
    self.selectAll = !self.selectAll;
    if(self.selectAll){
        [self.selectALLBtn setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
    }else{
        [self.selectALLBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(selectAllShopGoods:)]){
        [self.delegate selectAllShopGoods:self.selectAll];
    }
}

@end
