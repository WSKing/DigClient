//
//  TLBigPhotoCell.h
//  DigClient
//
//  Created by wsk on 2018/5/7.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBigPhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *showImage;
@property (nonatomic, assign) BOOL hideDelete;
@property (nonatomic, copy) void (^deletePhoto)(void);
@property (nonatomic, copy) void (^sureAndClose)(void);
@end
