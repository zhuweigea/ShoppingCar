//
//  ShoppingCarViewController.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarModel.h"
#import "ShoppingCarCell.h"
#import "ShoppingCarView.h"
#import "CustomHeaderView.h"
#import "CustomFooterView.h"
#import "UIViewController+ExtendCtr.h"

@interface ShoppingCarViewController ()<UITableViewDataSource,UITableViewDelegate,ShoppingCarViewDelegate,ShoppingCarCellDelegate,CustomHeaderViewDelegate>

@property(nonatomic, strong) dispatch_block_t deleteSelectedCell;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 记录选中的cell*/
@property (nonatomic,strong)NSMutableArray *selectedCellArr;

@property(nonatomic, strong) UITableView *tv;
@property(nonatomic, strong) ShoppingCarView *shoppingCarBottomView;

//是否全选
@property(nonatomic, assign) BOOL selectAll;

@end

@implementation ShoppingCarViewController

-(UITableView *)tv{
    if(!_tv){
        _tv = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHeight, SCREENWIDTH, SCREENHEIGHT-kStatusHeight-kSafeAreaBottom) style:UITableViewStylePlain];
        _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tv.delegate = self;
        _tv.dataSource = self;
        _tv.sectionHeaderHeight = 40;
        _tv.sectionFooterHeight = 15;
        _tv.rowHeight = 100;
        [_tv registerNib:[UINib nibWithNibName:@"ShoppingCarCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShoppingCarCell class])];
        [_tv registerClass:[CustomHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([CustomHeaderView class])];
        [_tv registerClass:[CustomFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([CustomFooterView class])];
    }
    return _tv;
}

-(NSMutableArray *)dataArr{
    if(_dataArr==nil){
        NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"ShopCarData.plist" ofType:nil];
        NSArray *array = [NSMutableArray arrayWithContentsOfFile:pathStr];
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSDictionary *groupDict in array) {
            ShoppingCarGroupModel *groupModel = [ShoppingCarGroupModel mj_objectWithKeyValues:groupDict];
            [mutableArr addObject:groupModel];
        }
        _dataArr = [mutableArr mutableCopy];
    }
    return _dataArr;
}

- (NSMutableArray *)selectedCellArr{
    if(_selectedCellArr==nil){
        _selectedCellArr = [NSMutableArray array];
    }
    return _selectedCellArr;
}

- (ShoppingCarView *)shoppingCarBottomView{
    if(_shoppingCarBottomView == nil){
        _shoppingCarBottomView = [[ShoppingCarView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-kSafeAreaBottom-44, SCREENWIDTH, 44)];
        _shoppingCarBottomView.backgroundColor = [UIColor whiteColor];
        _shoppingCarBottomView.delegate = self;
    }
    return _shoppingCarBottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";
    [self.view addSubview:self.tv];
    [self.view addSubview:self.shoppingCarBottomView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingCarGroupModel *groupModel = self.dataArr[section];
    return groupModel.detail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCarGroupModel *groupModel = self.dataArr[indexPath.section];
    ShoppingCarGoodsModel *goodsModel = groupModel.detail[indexPath.row];
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShoppingCarCell class])];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"ShoppingCarCell" owner:nil options:nil].firstObject;
    }
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setInfo:goodsModel];
    return cell;
}

- (void)calculatePrice{
    NSInteger sum = 0;
    NSInteger value = 0 ;
    for (ShoppingCarGoodsModel *goodsModel in self.selectedCellArr) {
        value = [goodsModel.CDprice integerValue]*[goodsModel.CDchooseCount integerValue];
        sum = sum+value;
    }
    if(sum > 0){
        self.shoppingCarBottomView.totalPrice.text = [NSString stringWithFormat:@"总价：%ld元",(long)sum];
    }else{
        self.shoppingCarBottomView.totalPrice.text = @"总价：";
    }
}

- (void)deviseOrAddReloadDataAndTableView{
    [self calculatePrice];
}

- (void)selectGoodsCell:(ShoppingCarCell *)cell{
    ShoppingCarGroupModel *groupModel = self.dataArr[cell.section];
    if(self.selectAll){
        groupModel.selectGroup = cell.goodsModel.selectGoods;
        [self.selectedCellArr removeObject:cell.goodsModel];
    }else{
        if(cell.goodsModel.selectGoods){
            [self.selectedCellArr addObject:cell.goodsModel];
            BOOL allSelected = YES;
            for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
                if(!goodsModel.selectGoods){
                    allSelected = NO;
                }
            }
            groupModel.selectGroup = allSelected;
        }else{
            groupModel.selectGroup = NO;
            [self.selectedCellArr removeObject:cell.goodsModel];
        }
    }
    [self calculatePrice];
    [self.tv reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShoppingCarGroupModel *groupModel = self.dataArr[section];
    CustomHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CustomHeaderView class])];
    if(!headerView){
        headerView = [[CustomHeaderView alloc]initWithReuseIdentifier:NSStringFromClass([CustomHeaderView class])];
    }
    headerView.delegate = self;
    [headerView setInfo:groupModel];
    //遍历每组确定是否全选  当逐条选中时，全部都选中的时候，全选选项也选中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL allSelected = YES;
        for (ShoppingCarGroupModel *groupModel in self.dataArr) {
            if (!groupModel.selectGroup) {
                allSelected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(allSelected){
                [self.shoppingCarBottomView.selectALLBtn setImage:[UIImage imageNamed:@"color_choose"] forState:UIControlStateNormal];
                self.shoppingCarBottomView.selectAll = YES;
                self.selectAll = self.shoppingCarBottomView.selectAll;
            }else{
                [self.shoppingCarBottomView.selectALLBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
                self.shoppingCarBottomView.selectAll = NO;
                self.selectAll = self.shoppingCarBottomView.selectAll;
            }
        });
    });
    return headerView;
}

- (void)selectSection:(ShoppingCarGroupModel *)groupModel{
    if(self.selectAll){
        for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
            goodsModel.selectGoods = NO;
            [self.selectedCellArr removeObject:goodsModel];
        }
    }else{
        if(groupModel.selectGroup){
            for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
                goodsModel.selectGoods = groupModel.selectGroup;
                if([self.selectedCellArr containsObject:goodsModel]){
                    
                }else{
                   [self.selectedCellArr addObject:goodsModel];
                }
            }
        }else{
            for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
                goodsModel.selectGoods = NO;
                [self.selectedCellArr removeObject:goodsModel];
            }
        }
    }
    [self calculatePrice];
    [self.tv reloadData];
}

- (void)deleteGoodsCell:(ShoppingCarCell *)cell{
    if(self.selectAll){
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ShoppingCarGroupModel *groupModel = (ShoppingCarGroupModel *)obj;
            [groupModel.detail enumerateObjectsUsingBlock:^(ShoppingCarGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj == cell.goodsModel){
                    [self.selectedCellArr removeObject:obj];
                    [groupModel.detail removeObject:obj];
                    if(groupModel.detail.count == 0){
                        [self.dataArr removeObject:groupModel];
                    }else{
                        
                    }
                }
            }];
        }];
        if(!self.dataArr.count){
            [self.shoppingCarBottomView.selectALLBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
            self.shoppingCarBottomView.selectALLBtn.enabled = NO;
        }
    }else{
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ShoppingCarGroupModel *groupModel = (ShoppingCarGroupModel *)obj;
            if(groupModel.selectGroup){
                [groupModel.detail enumerateObjectsUsingBlock:^(ShoppingCarGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj == cell.goodsModel){
                        [self.selectedCellArr removeObject:obj];
                        [groupModel.detail removeObject:obj];
                        if(groupModel.detail.count == 0){
                            [self.dataArr removeObject:groupModel];
                        }else{
                            
                        }
                    }
                }];
            }else{
                [groupModel.detail enumerateObjectsUsingBlock:^(ShoppingCarGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj == cell.goodsModel){
                        if(cell.goodsModel.selectGoods){
                            [self.selectedCellArr removeObject:obj];
                            [groupModel.detail removeObject:obj];
                            if(groupModel.detail.count == 0){
                                [self.dataArr removeObject:groupModel];
                            }else{
                                
                            }
                        }else{
                            [groupModel.detail removeObject:obj];
                            if(groupModel.detail.count == 0){
                                [self.dataArr removeObject:groupModel];
                            }else{
                                
                            }
                        }
                    }
                }];
            }
        }];
        if(!self.dataArr.count){
            [self.shoppingCarBottomView.selectALLBtn setImage:[UIImage imageNamed:@"color_no_choose"] forState:UIControlStateNormal];
            self.shoppingCarBottomView.selectALLBtn.enabled = NO;
        }
    }
    [self calculatePrice];
    [self.tv reloadData];
}

- (void)selectAllShopGoods:(BOOL)isSelectAll{
    self.selectAll = isSelectAll;
    if(self.selectedCellArr.count){
        [self.selectedCellArr removeAllObjects];
    }
    if(self.selectAll){
        for (ShoppingCarGroupModel *groupModel in self.dataArr) {
            groupModel.selectGroup = isSelectAll;
            for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
                goodsModel.selectGoods = isSelectAll;
                [self.selectedCellArr addObject:goodsModel];
            }
        }
    }else{
        for (ShoppingCarGroupModel *groupModel in self.dataArr) {
            groupModel.selectGroup = NO;
            for (ShoppingCarGoodsModel *goodsModel in groupModel.detail) {
                goodsModel.selectGoods = NO;
            }
        }
    }
    [self calculatePrice];
    [self.tv reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CustomFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CustomFooterView class])];
    if(!footerView){
        footerView = [[CustomFooterView alloc]initWithReuseIdentifier:NSStringFromClass([CustomFooterView class])];
    }
    return footerView;
}

@end
