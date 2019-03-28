//
//  CustomHeaderView.h
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCarGroupModel;;

@protocol CustomHeaderViewDelegate <NSObject>

- (void)selectSection:(ShoppingCarGroupModel *)groupModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CustomHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong) UIButton *sectionBtn;
@property(nonatomic, strong) UILabel *shopNameLabel;

@property(nonatomic, strong) ShoppingCarGroupModel *groupModel;

- (void)setInfo:(ShoppingCarGroupModel *)groupModel;

@property(nonatomic, weak) id<CustomHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
