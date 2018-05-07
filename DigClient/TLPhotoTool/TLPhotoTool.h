//
//  TLPhotoTool.h
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^TLPhotoCompletionBlock)(NSArray *photos);

@interface TLPhotoTool : NSObject

+ (void)showPhotoLibrary:(BOOL)show maxCount:(NSInteger)maxCount forViewController:(UIViewController *)viewController completion:(TLPhotoCompletionBlock)completeBlock;
@end
