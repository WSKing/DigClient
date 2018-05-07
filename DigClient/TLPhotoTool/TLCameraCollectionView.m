//
//  TLCameraCollectionView.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLCameraCollectionView.h"
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
@interface TLCameraCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TLCameraCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = self.imageList[indexPath.row];
    cell.deleteIndex = indexPath.row;
    __weak typeof(self)weakSelf = self;
    [cell setDeletephoto:^(NSInteger index) {
        __strong typeof(weakSelf)strongSelf =weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(deletePhotoAtIndex:)]) {
            [strongSelf.delegate deletePhotoAtIndex:index];
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.showBigPhoto) {
        self.showBigPhoto(indexPath.row);
    }
   
}

- (void)setImageList:(NSArray *)imageList {
    _imageList = imageList;
    [self.collectionView reloadData];
}

#pragma mark --getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.bounds.size.height * SCREEN_WIDTH/SCREEN_HEIGHT, self.bounds.size.height);
        layout.minimumInteritemSpacing = 10.0f;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[TLCameraCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    }
    return _collectionView;
}

@end



@interface TLCameraCell ()
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation TLCameraCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configurSubViews];
    }
    return self;
}

- (void)configurSubViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.deleteBtn];
}

- (void)setDeleteIndex:(NSInteger)deleteIndex {
    _deleteIndex = deleteIndex;
}

- (void)deletePhoto:(UIButton *)sender {
    if (self.deletephoto) {
        self.deletephoto(self.deleteIndex);
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 20, 0, 20, 20)];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end

