//
//  ZHImageCell.m
//  PhotoKit
//
//  Created by 张恒 on 15/12/14.
//  Copyright © 2015年 张恒. All rights reserved.
//

#import "ZHImageCell.h"

@interface ZHImageCell ()



@end

@implementation ZHImageCell

- (void)setImagewith:(CellProperty *)image{
 
    self.image.image = image.image;
    _tickImageView.hidden = !image.isClicked;
    _image.alpha = image.isClicked ? 0.9 : 1;

    
}
- (UIImage *)getImage{
    return self.image.image;
    
}

- (void)prepareForReuse {
 
    [super prepareForReuse];
    self.image.image = nil;
    _tickImageView.hidden = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
