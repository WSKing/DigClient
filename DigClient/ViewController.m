//
//  ViewController.m
//  DigClient
//
//  Created by wsk on 2018/5/4.
//  Copyright © 2018年 TLBank. All rights reserved.
//

#import "ViewController.h"
#import "TLPhotoTool.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)photo:(UIButton *)sender {
   [TLPhotoTool showPhotoLibrary:YES maxCount:3 forViewController:self completion:^(NSArray *photos) {
       for (UIImage *image in photos) {
           NSLog(@"%@",image.description);
       }
    }];
    
//    [TLPhotoTool showPhotoLibrary:NO maxCount:1 forViewController:self completion:^(NSArray *photos) {
//
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
