//
//  TLPhotoLibraryCell.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLPhotoLibraryCell.h"

@implementation TLPhotoLibraryCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
    }
    return self;
}

- (void)configureSubViews {
    [self.contentView addSubview:self.imgVIew];
//    [self.contentView addSubview:self.selectedImgView];
    [self.contentView addSubview:self.selectedBtn];
}

- (void)selectedPhoto:(UIButton *)sender {
    if (self.selectedBtnClicked) {
        self.selectedBtnClicked(sender);
    }
}

- (UIImageView *)imgVIew {
    if (!_imgVIew) {
        _imgVIew = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imgVIew.userInteractionEnabled = YES;
    }
    return _imgVIew;
}
/*
- (UIImageView *)selectedImgView {
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 30, 10, 20, 20)];
        _selectedImgView.image = [UIImage imageNamed:@"photo_selected"];
    }
    return _selectedImgView;
}
*/
- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds) - 30, 10, 20, 20)];
        [_selectedBtn setImage:[UIImage imageNamed:@"photo_unSelected"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"photo_selected"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(selectedPhoto:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn.selected = NO;
    }
    return _selectedBtn;
}

@end
