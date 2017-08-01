//
//  XQImageView.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQImageView.h"
#import "XPQGifView.h"

#define HandDoubleTap 2
#define HandOneTap 1
#define MaxZoomScaleNum 5.0
#define MinZoomScaleNum 1.0

@interface XQImageView ()<UIScrollViewDelegate>
{
    ImageType _imageType;       //图片来源类型
    UIImage *_image;            //图片对象
    NSData *_gifData;           //GIF图片资源
    XPQGifView *_gifView;       //gif视图
    UIImageView *_imageView;    //普通图片视图
}
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation XQImageView

#pragma mark - ----------Life Cycle
- (instancetype)init{
    self = [super init];
    if (self)
    {
        _imageType = TypeImageName;
        [self addGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageType = TypeImageName;
        [self addGesture];
    }
    return self;
}

- (void)addGesture{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.scrollView];
    
    //添加单、双击手势
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapsAction:)];
    [doubleTapGesture setNumberOfTapsRequired:HandDoubleTap];
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [singleTapGesture setNumberOfTapsRequired:HandOneTap];
    [self.scrollView addGestureRecognizer:singleTapGesture];
    
    self.scrollView.maximumZoomScale = MaxZoomScaleNum;
    self.scrollView.minimumZoomScale = MinZoomScaleNum;
    self.scrollView.zoomScale = MinZoomScaleNum;
}

#pragma mark - ----------External Interface
- (void)setViewImage:(id)image{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setObjectImage:(UIImage *)image];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        NSString *imagename = image;
        if ([self isURL:imagename])
        {
            [self setURLImage:[NSURL URLWithString:imagename]];
        }
        else
        {
            [self setNameImage:imagename];
        }
    }
    else if ([image isKindOfClass:[NSURL class]])
    {
        [self setURLImage:(NSURL *)image];
    }
    else
        return;
}

- (void)startGifImage{
    if (_gifView && !_gifView.isPlay)
    {
        [_gifView start];
    }
}

- (void)stopGifImage{
    if (_gifView && _gifView.isPlay)
    {
        [_gifView stop];
    }
}

#pragma mark - ----------ScrollView的代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (_imageView)
    {
        return _imageView;
    }
    else if (_gifView)
    {
        return _gifView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat Ws = self.scrollView.frame.size.width - self.scrollView.contentInset.left - self.scrollView.contentInset.right;
    CGFloat Hs = self.scrollView.frame.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
    if (_imageView)
    {
        CGFloat W = _imageView.frame.size.width;
        CGFloat H = _imageView.frame.size.height;
        
        CGRect rct = _imageView.frame;
        rct.origin.x = MAX((Ws-W)*0.5, 0);
        rct.origin.y = MAX((Hs-H)*0.5, 0);
        _imageView.frame = rct;
    }
    else if (_gifView)
    {
        CGFloat W = _gifView.frame.size.width;
        CGFloat H = _gifView.frame.size.height;
        
        CGRect rct = _gifView.frame;
        rct.origin.x = MAX((Ws-W)*0.5, 0);
        rct.origin.y = MAX((Hs-H)*0.5, 0);
        _gifView.frame = rct;
    }
}

#pragma mark - ----------手势方法
- (void)doubleTapsAction:(UITapGestureRecognizer *)tap{
    NSLog(@"双击");
    if (self.scrollView.minimumZoomScale <= self.scrollView.zoomScale && self.scrollView.maximumZoomScale > self.scrollView.zoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"单击");
    if (self.singleClickBlock)
    {
        self.singleClickBlock();
    }
}


#pragma mark - ----------Private Methods
#pragma mark -- 设置图片
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
        
        if ((_imageType == TypeImageName) || (_imageType == TypeImageObject) || (_imageType == TypeImageURL))
        {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            _imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
            [self.scrollView addSubview:_imageView];
            [_imageView setImage:_image];
        }
        else
        {
            if (_gifData != nil)
            {
                _gifView = [[XPQGifView alloc] initWithGifData:_gifData];
                _gifView.frame = CGRectMake(0, 0, width, height);
                _gifView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
                [self.scrollView addSubview:_gifView];
                [_gifView start];
            }
        }
    }
}

#pragma mark -- 设置根据UIImage对象的图片
- (void)setObjectImage:(UIImage *)image{
    _imageType = TypeImageObject;
    _image = image;
    [self setNormalImage];
}

#pragma mark -- 设置根据图片名的图片
- (void)setNameImage:(NSString *)imagename{
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

#pragma mark -- 设置根据图片URL的图片
- (void)setURLImage:(NSURL *)imageURL{
    NSString *imagePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@", [imageURL lastPathComponent]]];
    
    //从沙盒下的缓存目录查找图片，未找到则进行网络获取
    NSData *tempData = [NSData dataWithContentsOfFile:imagePath];
    if (tempData != nil)
    {
        _image = [UIImage imageWithData:tempData];
        NSString *tempImageType = [self contentTypeForImageData:tempData];
        if ([[tempImageType lowercaseString] isEqualToString:@"gif"])
        {
            _imageType = TypeImageGIFURL;
            _gifData = tempData;
        }
        else
        {
            _imageType = TypeImageURL;
        }
        [self setNormalImage];
    }
    else
    {
        dispatch_async(dispatch_queue_create("com.xuqian.image", DISPATCH_QUEUE_CONCURRENT), ^{
            NSError *error;
            __block NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:imageURL] returningResponse:NULL error:&error];
            
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
                    
                    //缓存下载的图片到沙盒下的cache目录
                    [data writeToFile:imagePath atomically:YES];
                }
            });
        });
    }
}

#pragma mark -- 判断字符串是否是url
- (BOOL)isURL:(NSString *)string
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:string];
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

#pragma mark - ----------Getter
- (UIScrollView *)scrollView{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end
