//
//  TLPhotoTool.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLPhotoTool.h"
#import "TLSheetTool.h"
#import "TLPhotoLibraryController.h"
#import "TLCameraController.h"
@interface TLPhotoTool()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TLPhotoLibraryDelegate, TLCameraFinishedDelegate>
@property (nonatomic, copy) TLPhotoCompletionBlock completion;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation TLPhotoTool
static TLPhotoTool *_photoTool;

+ (TLPhotoTool *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _photoTool = [[TLPhotoTool alloc] init];
    });
    return _photoTool;
}


+ (void)showPhotoLibrary:(BOOL)show maxCount:(NSInteger)maxCount forViewController:(UIViewController *)viewController completion:(TLPhotoCompletionBlock)completeBlock {
    
    TLPhotoTool *tool = [TLPhotoTool shareInstance];
    tool.completion = completeBlock;
    tool.maxCount = maxCount;
    
    if (show) {
        //从相机和相册两个方式
        [TLSheetTool showSheetType:TLSheetTitle_Top title:@"选择方式" cancleItem:@"取消" otherItems:@[@"相机",@"相册"] clickedBlock:^(BOOL isCancle, NSInteger index) {
            if (isCancle) {
                return ;
            }else {
                if (index) {
                    //相册
                    TLPhotoLibraryController *ctrl = [[TLPhotoLibraryController alloc] init];
                    ctrl.maxCount = maxCount;
                    ctrl.delegate = tool;
                    [viewController.navigationController pushViewController:ctrl animated:YES];
                }else {
                    //相机
                 
                        TLCameraController *ctrl = [[TLCameraController alloc] init];
                        ctrl.maxCount = maxCount;
                        ctrl.delegate = tool;
                        [viewController.navigationController pushViewController:ctrl animated:YES];
                }
            }
        }];
        
    }else {
        TLCameraController *ctrl = [[TLCameraController alloc] init];
        ctrl.maxCount = maxCount;
        ctrl.delegate = tool;
        [viewController.navigationController pushViewController:ctrl animated:YES];
    }
}

//相册已选完回调
- (void)didFinishedChoosePhotoInLibrary:(NSArray *)imageList {
    if (self.completion) {
        self.completion(imageList);
    }
}

//相机完成的回调
- (void)cameraDidFinishTakePhoto:(NSArray *)imageList {
    if (self.completion) {
        self.completion(imageList);
    }
}

@end
