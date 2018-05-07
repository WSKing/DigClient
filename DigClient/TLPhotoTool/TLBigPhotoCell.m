//
//  TLBigPhotoCell.m
//  DigClient
//
//  Created by wsk on 2018/5/7.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "TLBigPhotoCell.h"
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
@interface TLBigPhotoCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation TLBigPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    self.imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.imgView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 80, self.contentView.frame.size.width, 80)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self.contentView addSubview:bottomView];

    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 25, 40, 30)];
    [self.deleteBtn  setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteBtn  addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.deleteBtn ];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 40 - 40, 25, 40, 30)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
}

- (void)setHideDelete:(BOOL)hideDelete {
    _hideDelete = hideDelete;
    self.deleteBtn.hidden = hideDelete;
}

- (void)deletePhoto:(UIButton *)sender {
    if (self.deletePhoto) {
        self.deletePhoto();
    }
}

- (void)sure {
    if (self.sureAndClose) {
        self.sureAndClose();
    }
}

- (void)setShowImage:(UIImage *)showImage {
    _showImage = showImage;
    float roate = showImage.size.height * 1.0 / showImage.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    self.imgView.frame = CGRectMake(0,(height - SCREEN_WIDTH * roate)/2 , SCREEN_WIDTH, SCREEN_WIDTH * roate);
    self.imgView.image = showImage;
    
}
@end
