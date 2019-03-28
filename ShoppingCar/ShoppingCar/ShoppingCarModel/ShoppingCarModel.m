//
//  ShoppingCarModel.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

@end

@implementation ShoppingCarGroupModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"detail":@"ShoppingCarGoodsModel"
             };
}

@end

@implementation ShoppingCarGoodsModel

@end
