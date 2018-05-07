//
//  TLCameraCollectionView.h
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TLCameraDeletePhotoDelegate<NSObject>
- (void)deletePhotoAtIndex:(NSInteger)index;
@end


@interface TLCameraCollectionView : UIView
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, copy) void (^showBigPhoto)(NSInteger index);
@property (nonatomic, weak) id <TLCameraDeletePhotoDelegate>delegate;
@end

@interface TLCameraCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger deleteIndex;
@property (nonatomic, copy) void (^deletephoto)(NSInteger index);
@end

