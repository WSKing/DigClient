//
//  TLSheetTool.h
//  AutoLayout
//
//  Created by wsk on 2018/4/20.
//  Copyright © 2018年 WSK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TLSheetToolClickBlock)(BOOL isCancle, NSInteger index);

typedef enum : NSUInteger {
    TLSheetTitle_Bottom,
    TLSheetTitle_Top,
    TLSheetTitle_None,
}TLSheetTitleType ;

/**
 标题在下:无cancle
 标题在上:cancle在上
 无标题:cancle在下
 */
@interface TLSheetTool : NSObject

//无标题
+ (void)showSheetWithItems:(NSArray<NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block;

//默认标题在上
+ (void)showSheetTitle:(NSString *)title cancleItem:(NSString *)cancleItem otherItems:(NSArray <NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block;

+ (void)showSheetType:(TLSheetTitleType)type title:(NSString *)title cancleItem:(NSString *)cancleItem otherItems:(NSArray <NSString *> *)otherItems clickedBlock:(TLSheetToolClickBlock)block;
@end
