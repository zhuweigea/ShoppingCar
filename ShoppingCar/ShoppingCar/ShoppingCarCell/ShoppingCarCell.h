//
//  ShoppingCarCell.h
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCarGoodsModel;
@class ShoppingCarCell;

@protocol ShoppingCarCellDelegate <NSObject>

- (void)deviseOrAddReloadDataAndTableView;

- (void)selectGoodsCell:(ShoppingCarCell *)cell;

- (void)deleteGoodsCell:(ShoppingCarCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectRow;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *deviseLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearGoods;

- (void)setInfo:(ShoppingCarGoodsModel *)goodsModel;

@property(nonatomic, strong) ShoppingCarGoodsModel *goodsModel;

@property(nonatomic, weak) id<ShoppingCarCellDelegate> delegate;

@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) NSInteger row;

@end

NS_ASSUME_NONNULL_END
