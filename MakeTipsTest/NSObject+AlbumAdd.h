//
//  NSObject+AlbumAdd.h
//  Allcaster
//
//  Created by ws on 16/7/8.
//  Copyright © 2016年 Starsand. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (AlbumAdd)

/** 单张图片
 *  添加图片/ 上传照片...
 */
+ (void)addAlumByController:(UIViewController *)controller indexPath:(NSIndexPath*)indexPath;




/**
 *  相册多图选择  maxCount 为可选个NSUInteger
 *
 *  @param controller 外部控制器
 *  @param count      由外部控制器决定
 */
+ (void)addPicturesByController:(UIViewController *)controller withMaxCount:(NSUInteger )count;
@end
