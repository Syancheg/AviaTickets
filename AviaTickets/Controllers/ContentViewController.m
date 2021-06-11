//
//  ContentViewController.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation ContentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, [UIScreen mainScreen].bounds.size.height/2 - 100.0, 200.0, 200.0)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = 8.0;
        self.imageView.clipsToBounds = YES;
        [self.view addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMinY(self.imageView.frame) - 61.0, 200.0, 21.0)];
        self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightHeavy];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMaxY(self.imageView.frame) + 20.0, 200.0, 21.0)];
        self.contentLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.contentLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    float height = heightForText(title, _titleLabel.font, 200.0);
    _titleLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMinY(_imageView.frame) - 40.0 - height, 200.0, height);
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    _contentLabel.text = contentText;
    float height = heightForText(contentText, _contentLabel.font, 200.0);
    _contentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMaxY(_imageView.frame) + 20.0, 200.0, height);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
    _imageView.backgroundColor = [UIColor purpleColor];
}

float heightForText(NSString *text, UIFont *font, float width) {
    if (text && [text isKindOfClass:[NSString class]]) {
        CGSize size = CGSizeMake(width, FLT_MAX);
        CGRect needLabel = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return ceilf(needLabel.size.height);
    }
    return 0.0;
}

@end
