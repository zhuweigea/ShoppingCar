//
//  ShoppingCarView.h
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCarViewDelegate <NSObject>

//选中所有商品
- (void)selectAllShopGoods:(BOOL)isSelectAll;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarView : UIView

@property(nonatomic, assign) BOOL selectAll;
@property(nonatomic, strong) UIButton *selectALLBtn;
@property(nonatomic, strong) UILabel *totalPrice;
@property(nonatomic, strong) UIButton *calculateBtn;

@property(nonatomic, weak) id<ShoppingCarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
