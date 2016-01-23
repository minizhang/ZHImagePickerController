//
//  ViewController.m
//  图片选择_1-16
//
//  Created by 张恒 on 16/1/16.
//  Copyright © 2016年 zhangheng. All rights reserved.
//

#import "ViewController.h"
#import "ZHImageCollectionViewController.h"


@interface ViewController ()<ZHImageVcDelegate>

@property (strong, nonatomic) NSArray * image;
@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end

@implementation ViewController

- (void)imagePicker:(NSArray *)images{
    _image = images;
    _photo.image = [images lastObject];
}


- (IBAction)chouseImage:(id)sender {

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
