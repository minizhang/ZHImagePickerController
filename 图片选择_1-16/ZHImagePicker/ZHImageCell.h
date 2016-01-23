//
//  ZHImageCell.h
//  PhotoKit
//
//  Created by 张恒 on 15/12/14.
//  Copyright © 2015年 张恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellProperty.h"

@interface ZHImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (void)setImagewith:(CellProperty *)image;
- (UIImage *)getImage;
@end
