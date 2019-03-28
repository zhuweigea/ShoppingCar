//
//  ShoppingCarCell.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ShoppingCarCell.h"
#import "ShoppingCarModel.h"

@implementation ShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectRow setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    [self.selectRow addTarget:self action:@selector(selectCell) forControlEvents:UIControlEventTouchUpInside];
    self.goodsImage.clipsToBounds = YES;
    self.goodsImage.layer.cornerRadius = 3;
    self.deviseLabel.layer.borderWidth = 1;
    self.deviseLabel.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.countLabel.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.countLabel.layer.borderWidth = 1;
    self.addLabel.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.addLabel.layer.borderWidth = 1;
    self.lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.deviseLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *deviseGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deviseCount:)];
    [self.deviseLabel addGestureRecognizer:deviseGesture];
    self.addLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *addGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCount:)];
    [self.addLabel addGestureRecognizer:addGesture];
}

- (void)setInfo:(ShoppingCarGoodsModel *)goodsModel{
    self.goodsModel = goodsModel;
    if(goodsModel.selectGoods){
        [self.selectRow setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
    }else{
        [self.selectRow setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    }
    self.goodsImage.image = [UIImage imageNamed:goodsModel.CDimage];
    self.goodsName.text = goodsModel.CDname;
    self.countLabel.text = goodsModel.CDchooseCount;
    self.priceLabel.text = [NSString stringWithFormat:@"%d*%d",([goodsModel.CDchooseCount intValue]),([goodsModel.CDprice intValue])];
}

//减少商品数量
- (void)deviseCount:(UITapGestureRecognizer *)tap{
    self.deviseLabel = (UILabel *)tap.view;
    int devise = [self.countLabel.text intValue];
    if(devise==1){
        self.deviseLabel.enabled = NO;
    }else{
        --devise;
        self.countLabel.text = [NSString stringWithFormat:@"%d",devise];
        self.priceLabel.text = [NSString stringWithFormat:@"%d*%d",devise,([self.goodsModel.CDprice intValue])];
        self.goodsModel.CDchooseCount = self.countLabel.text;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(deviseOrAddReloadDataAndTableView)]){
            [self.delegate deviseOrAddReloadDataAndTableView];
        }
    }
}

//增加商品数量
- (void)addCount:(UITapGestureRecognizer *)tap{
    self.addLabel = (UILabel *)tap.view;
    int add = [self.countLabel.text intValue];
    ++add;
    self.countLabel.text = [NSString stringWithFormat:@"%d",add];
    self.priceLabel.text = [NSString stringWithFormat:@"%d*%d",add,([self.goodsModel.CDprice intValue])];
    self.goodsModel.CDchooseCount = self.countLabel.text;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(deviseOrAddReloadDataAndTableView)]){
        [self.delegate deviseOrAddReloadDataAndTableView];
    }
}

- (void)selectCell{
    self.goodsModel.selectGoods = !self.goodsModel.selectGoods;
    if(self.goodsModel.selectGoods){
        [self.selectRow setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
    }else{
        [self.selectRow setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(selectGoodsCell:)]){
        [self.delegate selectGoodsCell:self];
    }
}

- (IBAction)clearGoods:(UIButton *)sender {
    if(self.delegate&&[self.delegate respondsToSelector:@selector(deleteGoodsCell:)]){
        [self.delegate deleteGoodsCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
