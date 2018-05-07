//
//  TLPhotoLibraryController.h
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLPhotoLibraryDelegate<NSObject>
- (void)didFinishedChoosePhotoInLibrary:(NSArray *)imageList;
@end

@interface TLPhotoLibraryController : UIViewController

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) id <TLPhotoLibraryDelegate> delegate;
@end
