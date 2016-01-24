//
//  ZHAuthoriteJudge.m
//  图片选择_1-16
//
//  Created by 张恒 on 16/1/23.
//  Copyright © 2016年 zhangheng. All rights reserved.
//

#import "ZHAuthoriteJudge.h"
#import "ZHImageCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ZHAuthoriteJudge

+ (void)judeFromVc:(UIViewController<ZHImageVcDelegate> *)viewController andImageNum:(NSInteger)num{
 
    
    //判断系统版本。
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    
    if(version >= 8.0f){
            //如果版本是8.0以上走这个流程
            PHAuthorizationStatus Status_ph = [PHPhotoLibrary authorizationStatus];//用户权限状态
            
            if (Status_ph == PHAuthorizationStatusNotDetermined) {//如果用户买没有设置时候权限
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if(status == PHAuthorizationStatusAuthorized){//如果用户允许了访问
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:num];
                            vc.delegate = viewController;
                            [viewController.navigationController pushViewController:vc animated:YES];
                        });
                        
                        
                    }
                }];
            }else if(Status_ph == PHAuthorizationStatusAuthorized){
                
                ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:num];
                vc.delegate = viewController;
                [viewController.navigationController pushViewController:vc animated:YES];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您未允许访问您的照片" message:@"请前往设置-隐私-照片中允许“途虎养车”访问您的照片库" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
        
    }else{
        //如果版本是7.0走这个流程
             ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
            if (authorizationStatus == ALAuthorizationStatusNotDetermined) {//用户还没有决定是否允许访问照片
                ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
                NSMutableArray * albumsArray = [NSMutableArray array];
                
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    
                    if (group) {
                        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                        if (group.numberOfAssets > 0) {
                            // 把相册储存到数组中，方便后面展示相册时使用
                            // 此数组为相册的数组，以相册（group）为单位
                            [albumsArray addObject:group];
                        }
                    } else {
                        
                        if ([albumsArray count] > 0) {//说明用户允许了访问照片库
                            dispatch_async(dispatch_get_main_queue(), ^{
                                ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:num];
                                vc.delegate = viewController;
                                [viewController.navigationController pushViewController:vc animated:YES];
                            });
                           
                        }
                    }
                } failureBlock:^(NSError *error) {
//                    NSLog(@"Asset group not found!\n");
                }];
            }else if (authorizationStatus == ALAuthorizationStatusAuthorized ){
                
                ZHImageCollectionViewController *vc = [ZHImageCollectionViewController ImageCollectionVcWithImageNum:num];
                vc.delegate = viewController;
                [viewController.navigationController pushViewController:vc animated:YES];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您未允许访问您的照片" message:@"请前往设置-隐私-照片中允许“途虎养车”访问您的照片库" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }

    }
    
    
    
    
}




@end
