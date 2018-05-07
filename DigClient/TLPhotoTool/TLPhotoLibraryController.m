//
//  TLPhotoLibraryController.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLPhotoLibraryController.h"
#import <Photos/Photos.h>
#import "TLBigPhotoController.h"
#import "TLPhotoLibraryCell.h"
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
#define iPhone_X                 (SCREEN_HEIGHT == 812.0)

@interface TLPhotoLibraryController ()<UICollectionViewDelegate, UICollectionViewDataSource,PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imgsList;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImgList;
@end

@implementation TLPhotoLibraryController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择相片";
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    [library registerChangeObserver:self];
    [self requestLocalPhoto];
    [self.view addSubview:self.collectionView];
}
//相册权限发生改变(如果是第一次进应用之前没有同意相册权限,第一次进来后同意是会是空的界面,下面方法解决)
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self requestLocalPhoto];
}

- (void)requestLocalPhoto {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
    }  else {
        //这里就是用权限
        [self getAllAssetInPhotoAblumWithAscending:YES];
    }
}

#pragma mark --delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgsList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLPhotoLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TLPhotoLibraryCell class]) forIndexPath:indexPath];
    
    cell.imgVIew.image = self.imgsList[indexPath.row];
    __weak typeof(self)weakSelf = self;
    [cell setSelectedBtnClicked:^(UIButton *sender) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf selectedBtnClicked:sender indexPath:indexPath];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        //浏览大图
    TLBigPhotoController *ctrl = [[TLBigPhotoController alloc] initWithImageList:self.imgsList showIndex:indexPath.row];
    ctrl.hideDelete = YES;
    [self presentViewController:ctrl animated:YES completion:nil];
}

#pragma mark --func
- (void)sureAction {
    if (self.delegate) {
        [self.delegate didFinishedChoosePhotoInLibrary:self.selectedImgList];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectedBtnClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    if (!sender.selected) {
        if (self.selectedImgList.count < self.maxCount) {
            sender.selected = !sender.selected;
            [self.selectedImgList addObject:self.imgsList[indexPath.row]];
        }else {
            NSLog(@"最多%ld张",self.maxCount);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"最多选取%ld张",self.maxCount] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else {
        sender.selected = !sender.selected;
        [self.selectedImgList removeObject:self.imgsList[indexPath.row]];
    }
}

//读取所有图片
- (void)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    CGSize size = CGSizeMake((SCREEN_WIDTH - 4 * 5)/3, (SCREEN_WIDTH - 4 * 5)/3);
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //解析图片
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //仅显示缩略图，不控制质量显示
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.networkAccessAllowed = YES;
        //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
        __weak typeof(self)weakSelf = self;
        [[PHCachingImageManager defaultManager] requestImageForAsset:obj targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.imgsList addObject:image];
            if (strongSelf.imgsList.count == result.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.collectionView reloadData];
                });
            }
        }];
    }];
}


#pragma mark --lazy init
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 4 * 5)/3, (SCREEN_WIDTH - 4 * 5)/3);
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 0, 5);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (iPhone_X ? 20 : 0)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TLPhotoLibraryCell class] forCellWithReuseIdentifier:NSStringFromClass([TLPhotoLibraryCell class])];
    }
    return _collectionView;
}

- (NSMutableArray<UIImage *> *)selectedImgList {
    if (!_selectedImgList) {
        _selectedImgList = [NSMutableArray array];
    }
    return _selectedImgList;
}

- (NSMutableArray<UIImage *> *)imgsList {
    if (!_imgsList) {
        _imgsList = [NSMutableArray array];
    }
    return _imgsList;
}


@end
