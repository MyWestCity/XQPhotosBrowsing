//
//  XQBigImageViewController.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQBigImageViewController.h"
#import "XQImageView.h"

@interface XQBigImageViewController ()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;   //当前显示图片下标
    NSInteger _lastIndex;      //上次显示的图片下标(用于判断是左滑还是右滑)
}
@property (nonatomic,strong) NSArray *arrayImage;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) NSMutableArray *arrayTempImage;    //临时存储的图片数组（最多三张）
@end

@implementation XQBigImageViewController

#pragma mark - ----------Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI{
    for (NSInteger i = _currentIndex - 1; i <= _currentIndex + 1; i++)
    {
        if ((i >= 0) && (i < [self.arrayImage count]))
        {
            XQImageView *imageView = [[XQImageView alloc] init];
            if (_currentIndex == 0)
            {
                [imageView setImage:self.arrayImage[i] atIndex:i - _currentIndex];
                imageView.center = CGPointMake(WINDOW_SCREEN_WIDTH*(i-_currentIndex) + WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
            }
            else
            {
                [imageView setImage:self.arrayImage[i] atIndex:i - _currentIndex + 1];
                imageView.center = CGPointMake(WINDOW_SCREEN_WIDTH*(i-_currentIndex+1) + WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
            }
            [self.mainScrollView addSubview:imageView];
            [self.arrayTempImage addObject:imageView];
        }
    }
    
    //设置 scrollView滚动宽度
    [self.mainScrollView setContentSize:CGSizeMake([self.arrayTempImage count] * WINDOW_SCREEN_WIDTH, 0)];
    
    //设置 scrollView当前偏移位置
    if (_currentIndex == 0)
    {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        [self.mainScrollView setContentOffset:CGPointMake(WINDOW_SCREEN_WIDTH, 0)];
    }
}

#pragma mark -- 刷新UI界面
- (void)updateUI{
    if (_currentIndex < _lastIndex)
    {
        //手指右滑
        
        /**
            删除temparray的第三张图片
         */
        if ((_currentIndex + 2) < [self.arrayImage count])
        {
            XQImageView *imageView = self.arrayTempImage.lastObject;
            if (imageView)
            {
                [imageView removeFromSuperview];
                [self.arrayTempImage removeLastObject];
            }
        }
        
        /**
            右移另两张图片
         */
        for (XQImageView *imageView in self.arrayTempImage)
        {
            if (imageView)
            {
                CGRect frame = imageView.frame;
                frame.origin.x += WINDOW_SCREEN_WIDTH;
                imageView.frame = frame;
            }
        }
        
        /**
            添加第一张图片
         */
        if (((_currentIndex - 1) >= 0) && ((_currentIndex - 1) < [self.arrayImage count]))
        {
            XQImageView *imageView = [[XQImageView alloc] init];
            [imageView setImage:self.arrayImage[_currentIndex - 1] atIndex:0];
            imageView.center = CGPointMake(WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
            [self.mainScrollView addSubview:imageView];
            [self.arrayTempImage insertObject:imageView atIndex:0];
        }
        
        
    }
    else if (_currentIndex > _lastIndex)
    {
        //手指左滑
        
        /**
            删除temporary的第一张图片
         */
        if (_currentIndex > 1)
        {
            XQImageView *imageView = self.arrayTempImage.firstObject;
            if (imageView)
            {
                [imageView removeFromSuperview];
                [self.arrayTempImage removeObjectAtIndex:0];
            }
        }
        
        /**
            左移另两张图片
         */
        for (XQImageView *imageView in self.arrayTempImage)
        {
            if (imageView)
            {
                CGRect frame = imageView.frame;
                frame.origin.x -= WINDOW_SCREEN_WIDTH;
                imageView.frame = frame;
            }
        }
        
        /**
            添加第三张图片
         */
        if ((_currentIndex + 1) < [self.arrayImage count])
        {
            XQImageView *imageView = [[XQImageView alloc] init];
            [imageView setImage:self.arrayImage[_currentIndex + 1] atIndex:2];
            imageView.center = CGPointMake(WINDOW_SCREEN_WIDTH*2 + WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
            [self.mainScrollView addSubview:imageView];
            [self.arrayTempImage addObject:imageView];
        }
    }
    
    _lastIndex = _currentIndex;
    
    if (_currentIndex == 0)
    {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        [self.mainScrollView setContentOffset:CGPointMake(WINDOW_SCREEN_WIDTH, 0)];
    }
    [self.mainScrollView setContentSize:CGSizeMake([self.arrayTempImage count]*WINDOW_SCREEN_WIDTH, 0)];
}

#pragma mark - ----------ScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.contentOffset.x == 0) && _currentIndex != 0)
    {
        _currentIndex--;
        [self updateUI];
    }
    else if ((scrollView.contentOffset.x == WINDOW_SCREEN_WIDTH) && _currentIndex == 0)
    {
        _currentIndex++;
        [self updateUI];
    }
    else if (scrollView.contentOffset.x == WINDOW_SCREEN_WIDTH*2)
    {
        _currentIndex++;
        [self updateUI];
    }
}

#pragma mark - ----------External Interface
- (void)setImageArray:(NSArray *)array{
    self.arrayImage = [NSArray arrayWithArray:array];
}

- (void)setCurrentIndex:(NSInteger)index
{
    _currentIndex = index;
    _lastIndex = _currentIndex;
}

#pragma mark - ----------Getter
- (NSArray *)arrayImage{
    if (!_arrayImage)
    {
        _arrayImage = [NSArray array];
    }
    return _arrayImage;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, 0, WINDOW_SCREEN_WIDTH, WINDOW_SCREEN_HEIGHT);
        _mainScrollView.backgroundColor = [UIColor blackColor];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (NSMutableArray *)arrayTempImage{
    if (!_arrayTempImage)
    {
        _arrayTempImage = [NSMutableArray array];
    }
    return _arrayTempImage;
}

#pragma mark -
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
