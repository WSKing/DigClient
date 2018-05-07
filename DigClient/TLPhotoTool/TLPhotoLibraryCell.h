//
//  TLPhotoLibraryCell.h
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPhotoLibraryCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imgVIew;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, copy) void (^selectedBtnClicked)(UIButton *sender);
@end
