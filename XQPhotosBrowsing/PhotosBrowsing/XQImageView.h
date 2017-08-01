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
    TypeImageGIFName,       //本地gif图片名
    TypeImageObject,        //图片对象
    TypeImageURL,           //普通图片地址
    TypeImageGIFURL         //gif图片地址
};

typedef void(^SingleClickBlock)();

@interface XQImageView : UIView
@property (nonatomic,copy) SingleClickBlock singleClickBlock;
/**
 *  brief  设置要显示的图片
 *  param  image  图片对象（本地图片名、图片URL、UIimage对象）
 */
- (void)setViewImage:(id)image;

/**
 *  brief  开始GIF动画
 *  param  nil
 */
- (void)startGifImage;

/**
 *  brief  开始GIF动画
 *  param  nil
 */
- (void)stopGifImage;
@end
