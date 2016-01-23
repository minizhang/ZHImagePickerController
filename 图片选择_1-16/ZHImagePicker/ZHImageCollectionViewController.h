//
//  ZHImageCollectionViewController.h
//  PhotoKit
//
//  Created by 张恒 on 15/12/14.
//  Copyright © 2015年 张恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellProperty.h"

@protocol ZHImageVcDelegate <NSObject>

//回调被选中的图片
- (void)imagePicker:(NSArray *)images;

@end

@interface ZHImageCollectionViewController : UICollectionViewController

@property (nonatomic, weak)id<ZHImageVcDelegate> delegate;


+ (instancetype) ImageCollectionVcWithImageNum:(NSInteger)number;


@end
