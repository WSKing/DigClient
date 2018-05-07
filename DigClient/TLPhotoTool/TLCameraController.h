//
//  TLCameraController.h
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLCameraFinishedDelegate<NSObject>
- (void)cameraDidFinishTakePhoto:(NSArray *)imageList;
@end

@interface TLCameraController : UIViewController
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) id <TLCameraFinishedDelegate>delegate;

@end
