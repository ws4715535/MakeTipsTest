//
//  NSObject+AlbumAdd.m
//  Allcaster
//
//  Created by ws on 16/7/8.
//  Copyright © 2016年 Starsand. All rights reserved.
//

#import "NSObject+AlbumAdd.h"

@implementation NSObject (AlbumAdd)



+ (void)addAlumByController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> *)controller indexPath:(NSIndexPath * )indexPath{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *take_photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [controller presentViewController:picker animated:YES completion:nil];
            }
    }];
    UIAlertAction *anblum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
           
            [controller presentViewController:picker animated:YES completion:nil];
        }
    }];
   
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:take_photo];
    [alertController addAction:anblum];
    [controller presentViewController:alertController animated:YES completion:nil];
   
}


//
//
//+ (void)addPicturesByController:(UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,QBImagePickerControllerDelegate>  *)controller withMaxCount:(NSUInteger )count{
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = controller;
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *take_photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            
//            [controller presentViewController:picker animated:YES completion:nil];
//        }
//    }];
//    UIAlertAction *anblum = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            
//            QBImagePickerController *multPicker = [[QBImagePickerController alloc] init];
//            multPicker.delegate = controller;
//            multPicker.mediaType = QBImagePickerMediaTypeImage;
//            multPicker.allowsMultipleSelection = YES;
//            multPicker.showsNumberOfSelectedAssets = YES;
//            multPicker.maximumNumberOfSelection = count;
//            [controller presentViewController:multPicker animated:YES completion:nil];
//        }
//    }];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        [controller dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [alertController addAction:cancel];
//    [alertController addAction:take_photo];
//    [alertController addAction:anblum];
//    [controller presentViewController:alertController animated:YES completion:nil];
//
//    
//    
//}

@end
