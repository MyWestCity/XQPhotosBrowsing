//
//  XQImageViewCell.m
//  XQPhotosBrowsing
//
//  Created by xuqian on 2017/8/1.
//  Copyright © 2017年 xuqian. All rights reserved.
//

#import "XQImageViewCell.h"

@implementation XQImageViewCell

#pragma mark - ----------Life Cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style frame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark - ----------External Interface
- (void)setImage:(id)image{
    if (_imageView == nil)
    {
        _imageView = [[XQImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setViewImage:image];
}

#pragma mark - ----------

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
