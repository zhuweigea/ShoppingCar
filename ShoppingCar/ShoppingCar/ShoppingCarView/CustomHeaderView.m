//
//  CustomHeaderView.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "CustomHeaderView.h"
#import "ShoppingCarModel.h"

@interface CustomHeaderView()
{
    UIView *_lineView;
}
@end
@implementation CustomHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sectionBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
        [self.sectionBtn addTarget:self action:@selector(selectSection) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sectionBtn];
        self.shopNameLabel = [[UILabel alloc]init];
        self.shopNameLabel.textAlignment = NSTextAlignmentCenter;
        self.shopNameLabel.textColor = [UIColor whiteColor];
        self.shopNameLabel.backgroundColor = [UIColor redColor];
        self.shopNameLabel.layer.cornerRadius = 3;
        self.shopNameLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.shopNameLabel];
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf;
    [self.sectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(weakSelf);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sectionBtn.mas_right).offset(10);
        make.centerY.equalTo(weakSelf);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopNameLabel.mas_left);
        make.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(39);
    }];
}

- (void)setInfo:(ShoppingCarGroupModel *)groupModel{
    self.groupModel = groupModel;
    if(groupModel.selectGroup){
        [self.sectionBtn setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
    }else{
        [self.sectionBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    }
    self.shopNameLabel.text = groupModel.name;
}

- (void)selectSection{
    self.groupModel.selectGroup = !self.groupModel.selectGroup;
    if(self.groupModel.selectGroup){
        [self.sectionBtn setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
    }else{
        [self.sectionBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(selectSection:)]){
        [self.delegate selectSection:self.groupModel];
    }
}

@end
