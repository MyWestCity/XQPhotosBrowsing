//
//  ViewController.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/7/25.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "ViewController.h"
#import "XQBigImageViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *arrayPhotos;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initPhotosData];
    [self initCollectionView];
}

- (void)initPhotosData
{
    NSArray *arrayPhotosName = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.gif", @"5.jpg", @"6.gif", @"7.gif", @"8.jpg", @"9.jpeg", @"10.jpg", @"11.jpg", @"12.jpg"];
    self.arrayPhotos = [NSMutableArray arrayWithArray:arrayPhotosName];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
}

#pragma mark - CollcetionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayPhotos count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width-10)/3.0, (collectionView.frame.size.width-10)/3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UICollectionViewCell alloc] init];
    }
    if (indexPath.row < [self.arrayPhotos count])
    {
        NSString *imagename = self.arrayPhotos[indexPath.row];
        if ([[[imagename pathExtension] lowercaseString] isEqualToString:@"gif"])
        {
            NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imagename ofType:@"gif"]];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:cell.bounds];
            webView.userInteractionEnabled = NO;
            [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            [cell addSubview:webView];
        }
        else
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:cell.bounds];
            [image setImage:[UIImage imageNamed:self.arrayPhotos[indexPath.row]]];
            [cell addSubview:image];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XQBigImageViewController *bigVC = [[XQBigImageViewController alloc] init];
    [bigVC setImageArray:self.arrayPhotos];
    [bigVC setCurrentIndex:indexPath.row];
    [self presentViewController:bigVC animated:YES completion:nil];
}

#pragma mark - Getter
- (NSMutableArray *)arrayPhotos
{
    if (!_arrayPhotos)
    {
        _arrayPhotos = [NSMutableArray array];
    }
    return _arrayPhotos;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
