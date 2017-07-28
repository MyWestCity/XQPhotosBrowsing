//
//  XQBigImageViewController.h
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBigImageViewController : UIViewController

/**
 *  descrption : 设置要显示的图片数组
 *  parameter  : 
 *          array : 图片数组（本地图片名、图片URL、UIimage对象）
 */
- (void)setImageArray:(NSArray *)array;

/**
 *  descrption : 设置第一次打开要显示的图片下标
 *  parameter  : 
 *          index : 图片下标
 */
- (void)setCurrentIndex:(NSInteger)index;
@end
