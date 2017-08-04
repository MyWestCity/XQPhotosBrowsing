//
//  XQBigImageViewController.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/28.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQBigImageViewController.h"
#import "XQImageView.h"
#import "XQImageViewCell.h"

@interface XQBigImageViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _currentIndex;   //当前显示图片下标
}
@property (nonatomic,strong) NSArray *arrayImage;
@property (nonatomic,strong) UITableView *mainTableView;;
@end

@implementation XQBigImageViewController

#pragma mark - ----------Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.mainTableView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (_currentIndex < [self.mainTableView numberOfRowsInSection:0])
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
//    });
}

#pragma mark - ----------TableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayImage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"imageViewCell";
//    XQImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    XQImageViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (nil == cell)
    {
        cell = [[XQImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault frame:CGRectMake(0, 0, self.mainTableView.frame.size.height, self.mainTableView.frame.size.width) reuseIdentifier:identifier];
    }
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    __weak XQBigImageViewController *weakself = self;
    cell.singleClickBlock = ^{
        _currentIndex = -1;
        [weakself stopOtherGifAnimation];
        
        /****************
         单击图片的回调,单击图片的自定义方法从这里开始写
         ****************/
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
    
    if (indexPath.row < [self.arrayImage count])
    {
        [cell setImage:self.arrayImage[indexPath.row]];
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _currentIndex = -1;
//    [self stopOtherGifAnimation];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentIndex = scrollView.contentOffset.y / WINDOW_SCREEN_WIDTH;
    [self stopOtherGifAnimation];
}

#pragma mark - ----------External Interface
- (void)setImageArray:(NSArray *)array{
    self.arrayImage = [NSArray arrayWithArray:array];
}

- (void)setCurrentIndex:(NSInteger)index
{
    _currentIndex = index;
}

#pragma mark - ----------Private Methods
- (void)stopOtherGifAnimation{
    NSIndexPath *indexPath;
    for (NSInteger i = 0; i < [self.arrayImage count]; i++)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        XQImageViewCell *cell = [self.mainTableView cellForRowAtIndexPath:indexPath];
        if (cell != nil)
        {
            if (i == _currentIndex)
            {
                [cell startGIFAnimation];
            }
            else
            {
                [cell stopGIFAnimation];
            }
            
            if (_currentIndex == -1)
            {
                [cell removeFromSuperview];
            }
        }
    }
}

#pragma mark - ----------Getter
- (NSArray *)arrayImage{
    if (!_arrayImage)
    {
        _arrayImage = [NSArray array];
    }
    return _arrayImage;
}

- (UITableView *)mainTableView{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SCREEN_HEIGHT, WINDOW_SCREEN_WIDTH) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor blackColor];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _mainTableView.center = CGPointMake(WINDOW_SCREEN_WIDTH/2.0, WINDOW_SCREEN_HEIGHT/2.0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = WINDOW_SCREEN_WIDTH;
        _mainTableView.pagingEnabled = YES;
        [_mainTableView registerClass:[XQImageViewCell class] forCellReuseIdentifier:@"imageViewCell"];
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (void)viewDidUnload{
    NSLog(@"exit");
}

#pragma mark -
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
