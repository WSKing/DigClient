//
//  TLBigPhotoController.h
//  DigClient
//
//  Created by wsk on 2018/5/7.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLBigPhotoDeleteDelegate<NSObject>
- (void)didDeletePhoto:(NSInteger)index;
@end

@interface TLBigPhotoController : UIViewController
- (instancetype)initWithImageList:(NSArray *)imageList showIndex:(NSInteger)index;

@property (nonatomic, assign) BOOL hideDelete;
@property (nonatomic, weak) id <TLBigPhotoDeleteDelegate>delegate;
@end
