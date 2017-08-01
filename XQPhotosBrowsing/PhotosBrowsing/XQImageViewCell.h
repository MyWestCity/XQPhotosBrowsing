//
//  XQImageViewCell.h
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/8/1.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQImageView.h"

@interface XQImageViewCell : UITableViewCell
{
    XQImageView *_imageView;
}
@property (nonatomic,copy) SingleClickBlock singleClickBlock;

/**
 *  brief  初始化tablecell
 *  param  style  风格
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style frame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  brief  设置要显示的图片
 *  param  image  图片对象（本地图片名、图片URL、UIimage对象）
 */
- (void)setImage:(id)image;

/**
 *  brief  开始GIF动画
 *  param  nil
 */
- (void)startGIFAnimation;

/**
 *  brief  停止GIF动画
 *  param  nil
 */
- (void)stopGIFAnimation;

@end
