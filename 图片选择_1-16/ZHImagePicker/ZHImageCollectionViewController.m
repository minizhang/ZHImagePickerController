//
//  ZHImageCollectionViewController.m
//  PhotoKit
//
//  Created by 张恒 on 15/12/14.
//  Copyright © 2015年 张恒. All rights reserved.
//

#import "ZHImageCollectionViewController.h"
#import "ZHImageCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CellProperty.h"


#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface ZHImageCollectionViewController () <PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UICollectionViewDataSource>

//PhotoKit
@property (nonatomic, strong) PHFetchResult *allPhotos;
@property (nonatomic, strong) PHCachingImageManager  *imageManager;

//AssetsLibrary
@property (nonatomic, strong)ALAssetsLibrary * assetsLibrary;
@property (nonatomic, strong)NSMutableArray * albumsArray;//相册数组

@property (nonatomic, strong)NSMutableArray * imagesArray;

@property (nonatomic, assign)BOOL isIOS7;
@property (nonatomic, assign)BOOL didBack;

@property (nonatomic, strong) NSMutableArray * selectedAssets;
@property (nonatomic, strong) NSMutableArray * selectedImages;//保存选中的图片

@property (nonatomic, assign) NSInteger imageMaxNumber;//最多被选中的图片数
@property (nonatomic, assign) NSInteger imageCurrentNumber;//当前选中的数量


@end



@implementation ZHImageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
//初始化数据
    _selectedImages = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _imagesArray = [NSMutableArray array];
    
//设置UICollectionViewFlowLayout
    CGFloat imageW;
    CGFloat margin = 1;
    imageW = (screenW - margin * 3) / 4;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(imageW, imageW);
    //设置inset
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置cell行间距
    flowLayout.minimumLineSpacing = margin;
    //设置cell列边距
    flowLayout.minimumInteritemSpacing = margin;
    
    self = [super initWithCollectionViewLayout:flowLayout];
    return self;
    
}

+ (instancetype) ImageCollectionVcWithImageNum:(NSInteger)number{
    
    ZHImageCollectionViewController *vc = [[ZHImageCollectionViewController alloc]init];
    vc.imageMaxNumber = number;
    return  vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置重用的Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZHImageCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //设置right UIBarButtonItem
    UIBarButtonItem *settting =[[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = settting;
    
    //判断系统版本。
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if(version >= 8.0f){
        
       [self imagesForHigherIOSVersion];
        self.isIOS7 = NO;
    }else{
        //使用ALAssetsLibrary
        [self getAllPictures];
        self.isIOS7 = YES;
    }
   
}

- (void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

//IOS7 ~ AssetsLibrary
- (void)getAllPictures{
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _albumsArray = [[NSMutableArray alloc] init];
    
    //此函数为异步请求,获取相册的数组
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                // 次数组为相册的数组，以相册（group）为单位
                [_albumsArray addObject:group];
            }
        } else {
            if ([_albumsArray count] > 0) {
                // 把所有的相册储存完毕，可以展示相册列表
                //遍历所有的相册
                for (ALAssetsGroup *gp in _albumsArray ) {
                    [gp enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (result) {
                            CellProperty * imgP = [[CellProperty alloc]init];

                            imgP.alAsset = result;
                            CGImageRef cgImage = [result thumbnail];
                            imgP.image = [UIImage imageWithCGImage:cgImage];
                            
                            [_imagesArray addObject:imgP];
                        } else {
                            [self.collectionView reloadData];
                        }
                    }];
                }
                
            } else {
                // 没有任何有资源的相册，输出提示
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
}

- (void)imagesForHigherIOSVersion{
   
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    self.allPhotos = allPhotos;
    
    //获取照片
    PHCachingImageManager  *imageManager = [[PHCachingImageManager  alloc] init];
    self.imageManager = imageManager;
    
    for (int i = 0; i < self.allPhotos.count; i++) {
        PHAsset * asset = self.allPhotos[i];
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            //用模型 保存图片、是否选中
            CellProperty *imgP = [[CellProperty alloc]init];
            imgP.image = result;
            imgP.phAsset = asset;
            [_imagesArray addObject:imgP];
            
        }];
    }
  [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

//回调
- (void)back {
    
    
    if (_selectedAssets.count < 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //确保back只被调用一次,防止内存泄露
    if (self.didBack == YES) {
        return;
    }
    self.didBack = YES;
    if (self.isIOS7) {
        
        for(int i = 0; i < _selectedAssets.count; i++) {
            ALAsset * asset = [_selectedAssets objectAtIndex:i];
            ALAssetRepresentation * res = [asset defaultRepresentation];
            CGImageRef cgImage = [res fullResolutionImage];
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            [_selectedImages addObject:image];
        }
        
        [self imageDidLoad];
    }else{
        //获取高清图片
        for(int i = 0; i < _selectedAssets.count; i++){
            PHAsset *asset = [_selectedAssets objectAtIndex:i];
            [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                //由于不同图片加载的速度大小不一样，所以最后添加到图片数组中的顺图与assets数组中的顺序可能不一样！
                [_selectedImages addObject:result];
                [self imageDidLoad];
            }];
        }
    }
    
}

- (void)imageDidLoad{
    if (_selectedImages.count == _selectedAssets.count) {
        if ([_delegate respondsToSelector:@selector(imagePicker:)]) {
            
            [_delegate imagePicker:_selectedImages];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ZHImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setImagewith:[self.imagesArray objectAtIndex:indexPath.item]];
   
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZHImageCell *cell = (ZHImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CellProperty *imgP = [_imagesArray objectAtIndex:indexPath.item];
    
    //如果点击的是被选中的图片
    if (imgP.isClicked == YES) {
        //  删除选中的图片
       
        if (_selectedAssets.count > 0) {
            
            self.imageCurrentNumber--;
            if (self.isIOS7) {
                [_selectedAssets removeObject:imgP.alAsset];
            }else{
                [_selectedAssets removeObject:imgP.phAsset];
            }
        }else{
            NSLog(@"删除选中照片数组出错");
        }
        
        imgP.isClicked = NO;
        cell.tickImageView.hidden = YES;
        
    }else{
        if (self.imageCurrentNumber < self.imageMaxNumber ) {
            
            self.imageCurrentNumber++;
            if (self.isIOS7) {
                [_selectedAssets addObject:imgP.alAsset];
            }else{
                [_selectedAssets addObject:imgP.phAsset];
            }
            imgP.isClicked = YES;
            cell.tickImageView.hidden = NO;
            if (self.imageCurrentNumber == self.imageMaxNumber) {
                [self back];
            }
        }
        
    }
    
    cell.image.alpha = imgP.isClicked ? 0.9 : 1;
   
    
}


#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
}

@end
