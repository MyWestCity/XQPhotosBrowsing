//
//  XQImageView.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQImageView.h"

@interface XQImageView ()
{
    ImageType _imageType;       //图片来源类型
    NSInteger _index;           //图片要显示的位置
    UIImage *_image;            //图片对象
    NSString *_imageName;       //图片名
}
@end

@implementation XQImageView

#pragma mark - ----------Life Cycle
- (instancetype)init{
    self = [super init];
    if (self)
    {
        _imageType = TypeImageName;
    }
    return self;
}

#pragma mark - ----------External Interface
- (void)setImage:(id)image atIndex:(NSInteger)index{
    _index = index;
    if ([image isKindOfClass:[UIImage class]])
    {
        //传过来的是UIImage对象
        _imageType = TypeImageObject;
        _image = image;
        [self setNormalImage];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        NSString *imagename = image;
        if ([[imagename.pathExtension lowercaseString] isEqualToString:@"gif"])
        {
            //传过来的是本地GIF图片名
            _imageType = TypeImageGIFName;
            _imageName = imagename;
        }
        else
        {
            //传过来的是本地普通图片名
            _imageType = TypeImageName;
            _image = [UIImage imageNamed:imagename];
            [self setNormalImage];
        }
    }
    else if ([image isKindOfClass:[NSURL class]])
    {
        NSString *imagename = [NSString stringWithContentsOfURL:image encoding:NSUTF8StringEncoding error:nil];
        if ([[imagename.pathExtension lowercaseString] isEqualToString:@"gif"])
        {
            //传过来的是GIF图片的URL
            _imageType = TypeImageGIFURL;
        }
        else
        {
            //传过来的是普通图片的URL
            _imageType = TypeImageURL;
            dispatch_async(dispatch_queue_create("com.xuqian.image", DISPATCH_QUEUE_CONCURRENT), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagename]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data != nil)
                    {
                        _image = [UIImage imageWithData:data];
                        [self setNormalImage];
                    }
                });
            });
        }
        _imageName = imagename;
    }
    else
        return;
}

#pragma mark - ----------Private Methods
- (void)setNormalImage{
    if (_image != nil)
    {
        CGFloat width = 0;
        CGFloat height = 0;
        if (_image.size.width <= WINDOW_SCREEN_WIDTH)
        {
            if (_image.size.height <= WINDOW_SCREEN_HEIGHT)
            {
                width = _image.size.width;
                height = _image.size.height;
            }
            else
            {
                height = WINDOW_SCREEN_HEIGHT;
                width = height*_image.size.width/_image.size.height;
            }
        }
        else
        {
            if (_image.size.height <= WINDOW_SCREEN_HEIGHT)
            {
                width = WINDOW_SCREEN_WIDTH;
                height = width*_image.size.height/_image.size.width;
            }
            else
            {
                if ((_image.size.width/_image.size.height) >= (WINDOW_SCREEN_WIDTH/WINDOW_SCREEN_HEIGHT))
                {
                    width = WINDOW_SCREEN_WIDTH;
                    height = width*_image.size.height/_image.size.width;
                }
                else
                {
                    height = WINDOW_SCREEN_HEIGHT;
                    width = height*_image.size.width/_image.size.height;
                }
            }
        }
        self.frame = CGRectMake(0, 0, width, height);
        self.center = CGPointMake(WINDOW_SCREEN_HEIGHT*_index + WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
        [self setImage:_image];
    }
}

- (void)setGIFImage{
    
}

@end
