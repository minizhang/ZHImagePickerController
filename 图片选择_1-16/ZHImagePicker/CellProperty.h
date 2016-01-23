//
//  CellProperty.h
//  PhotoKit
//
//  Created by 张恒 on 15/12/15.
//  Copyright © 2015年 张恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface CellProperty : NSObject

@property (nonatomic, strong)UIImage * image;
@property (nonatomic, strong)ALAsset *alAsset;
@property (nonatomic, strong)PHAsset *phAsset;
@property (nonatomic, assign)BOOL isClicked;

@end
