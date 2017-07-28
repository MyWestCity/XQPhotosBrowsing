//
//  XQImageView.h
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOW_SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width     //屏幕宽
#define WINDOW_SCREEN_HEIGHT        [UIScreen mainScreen].bounds.size.height    //屏幕高

typedef NS_ENUM(NSUInteger, ImageType){
    TypeImageName = 0,      //本地普通图片名
    TypeImageGIFName,   //本地gif图片名
    TypeImageObject,    //图片对象
    TypeImageURL,       //普通图片地址
    TypeImageGIFURL     //gif图片地址
};

@interface XQImageView : UIImageView
/**
 *  descrption : 设置要显示的图片
 *  parameter  : 
            image : 图片对象（本地图片名、图片URL、UIimage对象）
            index : 图片要显示的位置
 */
- (void)setImage:(id)image atIndex:(NSInteger)index;
@end