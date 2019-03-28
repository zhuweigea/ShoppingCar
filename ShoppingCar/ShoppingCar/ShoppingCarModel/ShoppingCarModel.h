//
//  ShoppingCarModel.h
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShoppingCarGoodsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarModel : NSObject

@end

@interface ShoppingCarGroupModel : NSObject

//是否选中当前组（包括一个商店的全部商品）
@property(nonatomic, assign) BOOL selectGroup;
//商店名字
@property(nonatomic, copy) NSString *name;
//商店里面的商品数组
@property(nonatomic, strong) NSMutableArray<ShoppingCarGoodsModel *> *detail;

+ (NSDictionary *)mj_objectClassInArray;

@end

@interface ShoppingCarGoodsModel : NSObject

@property(nonatomic, copy) NSString *CDimage;//商品图片
@property(nonatomic, copy) NSString *CDname;//商品名
@property(nonatomic, copy) NSString *CDprice;//商品价格
@property(nonatomic, copy) NSString *CDchooseCount;//订购商品数量

//是否选中当前行（某个商店的某件商品）
@property(nonatomic, assign) BOOL selectGoods;

@end

NS_ASSUME_NONNULL_END
