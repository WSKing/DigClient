//
//  TLBigPhotoController.m
//  DigClient
//
//  Created by wsk on 2018/5/7.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLBigPhotoController.h"
#import "TLBigPhotoCell.h"

#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
@interface TLBigPhotoController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger showIndex;
@end

@implementation TLBigPhotoController

- (instancetype)initWithImageList:(NSArray *)imageList showIndex:(NSInteger)index{
    self = [super init];
    if (self) {
        self.dataList = [NSMutableArray arrayWithArray:imageList];
        self.showIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark --collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLBigPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bigPhotoCell" forIndexPath:indexPath];
    __weak typeof(self)weakSelf = self;
    [cell setDeletePhoto:^{
        __strong typeof(weakSelf) strongSelf= weakSelf;
        [strongSelf deletePhoto:indexPath];
    }];
    [cell setSureAndClose:^{
        __strong typeof(weakSelf) strongSelf= weakSelf;
        [strongSelf sureAndClose];
    }];
    cell.hideDelete = self.hideDelete;
    cell.showImage = self.dataList[indexPath.row];
    return cell;
}

#pragma mark --func
- (void)deletePhoto:(NSIndexPath *)indexPath {
    [self.dataList removeObjectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeletePhoto:)]) {
        [self.delegate didDeletePhoto:indexPath.row];
    }
    if (self.dataList.count == 0) {
        [self sureAndClose];
    }else 
        [self.collectionView reloadData];
}

- (void)sureAndClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumInteritemSpacing = 0.01f;
        layout.minimumLineSpacing = 0.01f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_collectionView registerClass:[TLBigPhotoCell class] forCellWithReuseIdentifier:@"bigPhotoCell"];
    }
    return _collectionView;
}

@end
