//
//  TLSheetTool.m
//  AutoLayout
//
//  Created by wsk on 2018/4/20.
//  Copyright © 2018年 WSK. All rights reserved.
//

#import "TLSheetTool.h"
#import <UIKit/UIKit.h>
@interface TLSheetTool()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) TLSheetTitleType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancleBtn;
@property (nonatomic, strong) NSArray *otherItems;
@property (nonatomic, copy) TLSheetToolClickBlock block;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) UIView *bgView;
@end

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define ROW_HEIGHT      50.0f
#define MARGIN  10.0f
#define TITLE_HEIGHT    45.0f
@implementation TLSheetTool

static TLSheetTool *_sheet;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sheet = [[TLSheetTool alloc] init];
    });
    return _sheet;
}

+ (void)showSheetWithItems:(NSArray<NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block {
    [self showSheetType:TLSheetTitle_None title:nil cancleItem:@"取消" otherItems:otherItems clickedBlock:block];
}

+ (void)showSheetTitle:(NSString *)title cancleItem:(NSString *)cancleItem otherItems:(NSArray<NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block {
    [self showSheetType:TLSheetTitle_Bottom title:title cancleItem:cancleItem otherItems:otherItems clickedBlock:block];
}

+ (void)showSheetType:(TLSheetTitleType)type title:(NSString *)title cancleItem:(NSString *)cancleItem otherItems:(NSArray<NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block {
    TLSheetTool *sheet = [TLSheetTool sharedInstance];
    sheet.type = type;
    sheet.title = title;
    sheet.cancleBtn = cancleItem;
    sheet.otherItems = otherItems;
    sheet.block = block;
    [sheet configureSubView];
}

- (void)configureSubView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0];
    [self.bgView addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT - self.tableViewHeight , SCREEN_WIDTH, self.tableViewHeight);
    }];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tableViewHeight)];
    [self.bgView addSubview:tapView];
    tapView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapView addGestureRecognizer:tap];
}

#pragma mark --tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == TLSheetTitle_Bottom ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == TLSheetTitle_Bottom) {
        return self.otherItems.count;
    }else if (self.type == TLSheetTitle_Top) {
        return section ? 1 : self.otherItems.count;
    }else
        return section ? 1 : self.otherItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == TLSheetTitle_Bottom) {
        return 0.01f;
    }else if (self.type == TLSheetTitle_Top) {
        return section ? MARGIN : TITLE_HEIGHT;
    }else
        return section ? MARGIN : 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == TLSheetTitle_Bottom) {
        return [UIView new];
    }else if (self.type == TLSheetTitle_Top) {
        if (section == 0) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TITLE_HEIGHT)];
            titleLabel.font = [UIFont boldSystemFontOfSize:19];
            titleLabel.text = self.title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor orangeColor];
            return titleLabel;
        }else {
            return [UIView new];
        }
    }else
        return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.type == TLSheetTitle_Bottom) {
        return TITLE_HEIGHT;
    }else
        return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.type == TLSheetTitle_Bottom) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TITLE_HEIGHT)];
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
        titleLabel.text = self.title;
        titleLabel.textColor = [UIColor orangeColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        return titleLabel;
    }else
        return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HEIGHT)];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:itemLabel];
    
    if (self.type == TLSheetTitle_Bottom) {
        itemLabel.text = self.otherItems[indexPath.row];
    }else if (self.type == TLSheetTitle_Top) {
        if (indexPath.section == 1) {
            itemLabel.text = self.cancleBtn;
            itemLabel.textColor = [UIColor redColor];
        }else {
            itemLabel.text = self.otherItems[indexPath.row];
        }
    }else {
        if (indexPath.section == 0) {
            itemLabel.text = self.otherItems[indexPath.row];
        }else {
            itemLabel.text = self.cancleBtn;
            itemLabel.textColor = [UIColor redColor];
        }
    }
    
    return cell;
}

/**
 标题在下:无cancle
 标题在上:cancle在下
 无标题:cancle在下
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.type == TLSheetTitle_Bottom) {
        self.block(NO,indexPath.row);
    }else if (self.type == TLSheetTitle_Top) {
        if (indexPath.section == 0) {
            self.block(NO,indexPath.row);
        }else {
            self.block(YES, 0);
        }
    }else if (self.type == TLSheetTitle_None) {
        if (indexPath.section == 1) {
            //取消
            self.block(YES, 0);
        }else {
            self.block(NO, indexPath.row);
        }
    }
    [self closeSheet];
}

#pragma mark --actions
//关闭sheet
- (void)closeSheet {
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.tableViewHeight);
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        for (UIView *view in self.tableView.subviews) {
            [view removeFromSuperview];
        }
        self.tableView = nil;
        [self.bgView removeFromSuperview];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self closeSheet];
}

#pragma mark --getters
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = 0;
        switch (self.type) {
            case TLSheetTitle_Bottom:
                height = self.otherItems.count * ROW_HEIGHT + TITLE_HEIGHT ;
                break;
            case TLSheetTitle_Top:
                height = (self.otherItems.count + 1) * ROW_HEIGHT + TITLE_HEIGHT;
                break;
            case TLSheetTitle_None:
                height = (self.otherItems.count + 1) * ROW_HEIGHT + MARGIN;
            default:
                break;
        }
        self.tableViewHeight = height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = [UIColor colorWithWhite:200.0/255 alpha:0.7];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
        
        _tableView.rowHeight = ROW_HEIGHT;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
