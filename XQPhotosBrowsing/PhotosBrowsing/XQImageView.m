//
//  XQImageView.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQImageView.h"
#import "XPQGifView.h"

@interface XQImageView ()<UIGestureRecognizerDelegate>
{
    ImageType _imageType;       //图片来源类型
    NSInteger _index;           //图片要显示的位置
    UIImage *_image;            //图片对象
    CGFloat _lastScale;         //上次的缩放
    NSData *_gifData;           //GIF图片资源
    bool _isShow;
}
@property (nonatomic,strong) XPQGifView *gifView;
@end

@implementation XQImageView
@synthesize isShow = _isShow;

#pragma mark - ----------Life Cycle
- (instancetype)init{
    self = [super init];
    if (self)
    {
        _imageType = TypeImageName;
        _lastScale = 1.0;
        _index = 0;
        _isShow = false;
        self.userInteractionEnabled = YES;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        pinchRecognizer.delegate = self;
//        [self addGestureRecognizer:pinchRecognizer];
    }
    return self;
}

#pragma mark - ----------GestureRecognizer的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)zoomImage:(id)sender{
    if ([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
    {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer *)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer *)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[(UIPinchGestureRecognizer *)sender view]setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer *)sender scale];
}

#pragma mark - ----------External Interface
- (void)setImage:(id)image atIndex:(NSInteger)index{
//    _index = index;
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
            NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imagename ofType:nil]];
            if (gifData != nil)
            {
                _gifData = gifData;
            }
            _image = [UIImage imageNamed:imagename];
            [self setNormalImage];
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
        dispatch_async(dispatch_queue_create("com.xuqian.image", DISPATCH_QUEUE_CONCURRENT), ^{
            __block NSData *data = [NSData dataWithContentsOfURL:(NSURL *)image];
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                while (data == nil)
                {
                    data = [NSData dataWithContentsOfURL:(NSURL *)image];
                }
            });
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (data != nil)
                {
                    _image = [UIImage imageWithData:data];
                    NSString *imageType = [self contentTypeForImageData:data];
                    if ([[imageType lowercaseString] isEqualToString:@"gif"])
                    {
                        _imageType = TypeImageGIFURL;
                        _gifData = data;
                    }
                    else
                    {
                        _imageType = TypeImageURL;
                    }
                    [self setNormalImage];
                }
            });
        });
    }
    else
        return;
}

- (void)startGifImage{
    if (self.gifView && self.gifView.gifData)
    {
        [self.gifView start];
    }
}

- (void)suspendGifImage{
    if (self.gifView && self.gifView.gifData)
    {
        [self.gifView suspend];
    }
}

- (ImageType)getImageType
{
    return _imageType;
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
//        self.center = CGPointMake(WINDOW_SCREEN_HEIGHT*_index + WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
        if ((_imageType == TypeImageName) || (_imageType == TypeImageObject) || (_imageType == TypeImageURL))
        {
            [self setImage:_image];
        }
        else
        {
            if (_gifData != nil)
            {
                 self.gifView = [[XPQGifView alloc] initWithGifData:_gifData];
                self.gifView.frame = self.bounds;
                [self addSubview:self.gifView];
                [self.gifView start];
            }
        }
    }
}

#pragma mark -- 判断网络图片的类型
- (NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            
            if ([data length] < 12) {
                
                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            
            return nil;
            
    }
    
    return nil;
    
}


@end
