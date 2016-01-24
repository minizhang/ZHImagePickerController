//
//  ViewController.m
//  图片选择_1-16
//
//  Created by 张恒 on 16/1/16.
//  Copyright © 2016年 zhangheng. All rights reserved.
//

#import "ViewController.h"

#import "ZHImageCollectionViewController.h"
#import "ZHAuthoriteJudge.h"

@interface ViewController ()<ZHImageVcDelegate>

@property (strong, nonatomic) NSArray * image;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end


@implementation ViewController

#pragma mark  - ZHImageVcDelegate
- (void)imagePicker:(NSArray *)images{
    _image = images;
    _photo.image = [images lastObject];
}

- (IBAction)chouseImage:(id)sender {
    //image 选择的入口
    [ZHAuthoriteJudge judeFromVc:self andImageNum:1];
}


@end
