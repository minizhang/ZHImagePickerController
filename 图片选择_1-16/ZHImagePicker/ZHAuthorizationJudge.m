//
//  ZHAuthorizationJudge.m
//  Tuhu
//
//  Created by 张恒 on 16/1/22.
//  Copyright © 2016年 telenav. All rights reserved.
//

#import "ZHAuthorizationJudge.h"
#import "ZHImageCollectionViewController.h"
#import <Photos/Photos.h>

@interface ZHAuthorizationJudge()

@end

@implementation ZHAuthorizationJudge


+ (void)AuthorizationJudgeFromVC:(UIViewController *)viewController{
    
    PHAuthorizationStatus Status_ph = [PHPhotoLibrary authorizationStatus];
    
    if (Status_ph == PHAuthorizationStatusNotDetermined) {//如果用户买没有设置时候权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(Status_ph == PHAuthorizationStatusAuthorized){//如果用户允许了访问
                
                ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:1];
                vc.delegate = viewController;
                [viewController.navigationController pushViewController:vc animated:YES];

            }
        }];
    }else if(Status_ph == PHAuthorizationStatusAuthorized){
        
        ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:1];
        vc.delegate = viewController;
        [viewController.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您未允许访问您的照片" message:@"请前往设置-隐私-照片中允许“途虎养车”访问您的照片库" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    

}

@end
