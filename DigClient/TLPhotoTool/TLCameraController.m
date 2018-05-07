//
//  TLCameraController.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "TLCameraCollectionView.h"
#import "TLBigPhotoController.h"
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
@interface TLCameraController ()<TLCameraDeletePhotoDelegate,TLBigPhotoDeleteDelegate >
@property (nonatomic, strong) AVCaptureSession *session;//结合输入输出
@property (nonatomic, strong) AVCaptureDeviceInput *input;//输入设备
@property (nonatomic, strong) AVCaptureMetadataOutput *output;//
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong) AVCaptureDevice *device;//设备
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, strong) NSMutableArray *imageList;

@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *torchBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) TLCameraCollectionView *collectionView;
@end

@implementation TLCameraController

- (void)dealloc {
    [self.session stopRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeCamera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureCamera];
    [self configureSubViews];
}

- (void)configureCamera {
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
     if ([self.device lockForConfiguration:nil]) {
         if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
             
             self.session.sessionPreset = AVCaptureSessionPreset1280x720;
             
         }
         if ([self.session canAddInput:self.input]) {
             [self.session addInput:self.input];
         }
         
         if ([self.session canAddOutput:self.imageOutput]) {
             [self.session addOutput:self.imageOutput];
         }
     }
    [self.device unlockForConfiguration];
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.preLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.preLayer.frame = self.view.bounds;
    self.preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) return device;
    }
    return nil;
}

- (void)configureSubViews {
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.switchBtn];
//    [self.view addSubview:self.torchBtn];
    [self.view insertSubview:self.bottomView belowSubview:self.cameraBtn];
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)takePhoto:(UIButton *)sender {
    if (self.imageList.count == self.maxCount) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"最多拍摄%ld张",self.maxCount] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        [self takePhotoWithConnection:connection];
    }
}

- (void)takePhotoWithConnection:(AVCaptureConnection *)connection {
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (!imageDataSampleBuffer) {
            return ;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:imageData];
        [self.imageList addObject:image];
        NSLog(@"数量%ld",self.imageList.count);
        self.collectionView.hidden = self.imageList.count == 0;
        self.collectionView.imageList = self.imageList;
    }];
}

- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
            self.devicePosition = AVCaptureDevicePositionBack;
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
            self.devicePosition = AVCaptureDevicePositionFront;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.preLayer addAnimation:animation forKey:nil];
 
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        [self.session startRunning];
    }
}

- (void)torchSwitch{
    self.torchBtn.selected = ! self.torchBtn.selected;
    if ([self.device lockForConfiguration:nil]) {
        if (self.torchBtn.selected) {
            if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.device setFlashMode:AVCaptureFlashModeOff];
            }
        }else{
            if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [self.device setFlashMode:AVCaptureFlashModeAuto];
            }
        }
        
        [self.device unlockForConfiguration];
    }
}

- (void)sureAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraDidFinishTakePhoto:)]) {
        [self.delegate cameraDidFinishTakePhoto:self.imageList];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --delete photo delegate
- (void)deletePhotoAtIndex:(NSInteger)index {
    if (index < self.imageList.count) {
        [self.imageList removeObjectAtIndex:index];
        
        self.collectionView.hidden = self.imageList.count==0;
        self.collectionView.imageList = self.imageList;
    }
}

- (void)didDeletePhoto:(NSInteger)index {
    if (index < self.imageList.count) {
        [self.imageList removeObjectAtIndex:index];
        
        self.collectionView.hidden = self.imageList.count==0;
        self.collectionView.imageList = self.imageList;
    }
}

#pragma mark --getters
- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50)/2, SCREEN_HEIGHT - 10 - 50, 50, 50)];
        [_cameraBtn setImage:[UIImage imageNamed:@"photo_take"] forState:UIControlStateNormal];
        [_cameraBtn setImage:[UIImage imageNamed:@"photo_take"] forState:UIControlStateHighlighted];
        [_cameraBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (NSMutableArray *)imageList {
    if (!_imageList) {
        _imageList = [NSMutableArray array];
    }
    return _imageList;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40 - 40, SCREEN_HEIGHT - 15 - 40, 40, 40)];
        [_switchBtn setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIButton *)torchBtn {
    if (!_torchBtn) {
        _torchBtn  = [[UIButton alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT - 20 -45, 40, 40)];
        [_torchBtn setImage:[UIImage imageNamed:@"torch_off"] forState:UIControlStateNormal];
        [_torchBtn setImage:[UIImage imageNamed:@"torch_on"] forState:UIControlStateSelected];
        [_torchBtn addTarget:self action:@selector(torchSwitch) forControlEvents:UIControlEventTouchUpInside];
        _torchBtn.selected = NO;
    }
    return _torchBtn;
}

- (TLCameraCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[TLCameraCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70 - 100, SCREEN_WIDTH, 100)];
        _collectionView.delegate = self;
        __weak typeof(self)weakSelf = self;
        _collectionView.showBigPhoto = ^(NSInteger index) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            TLBigPhotoController *ctrl = [[TLBigPhotoController alloc] initWithImageList:strongSelf.imageList showIndex:index];
            ctrl.delegate = strongSelf;
            ctrl.hideDelete = NO;
            [strongSelf presentViewController:ctrl animated:YES completion:nil];
        };
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];;
    }
    return _bottomView;
}
@end
