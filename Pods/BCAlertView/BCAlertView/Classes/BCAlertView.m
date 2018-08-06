//
//  BCAlertView.m
//
//  Created by cloud on 2018/6/11.
//  Copyright © 2018年 cloud. All rights reserved.
//

#import "BCAlertView.h"
#import "Masonry.h"
// 屏幕宽度
#define kScreenWidth ((CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds))?(CGRectGetHeight([UIScreen mainScreen].bounds)):(CGRectGetWidth([UIScreen mainScreen].bounds)))

// 屏幕高度
#define kScreenHeight ((CGRectGetWidth([UIScreen mainScreen].bounds) > CGRectGetHeight([UIScreen mainScreen].bounds))?(CGRectGetWidth([UIScreen mainScreen].bounds)):(CGRectGetHeight([UIScreen mainScreen].bounds)))

#define kHexColor(value) [UIColor colorWithRed:((float)(((value) & 0xFF0000) >> 16))/255.0 green:((float)(((value) & 0xFF00) >> 8))/255.0 blue:((float)((value) & 0xFF))/255.0 alpha:1.0]
/*
 *  以iPhone6宽、高为标准的元单位
 */
#define kUnitWidth(width) (width*kScreenWidth/375)

#define kUnitHeight(height) (height*kScreenHeight/667)

#define kUnitFont(font) (kScreenWidth < 375 ? kUnitWidth(font) : font)
@implementation BCAlertView
- (id)initWithFrame:(CGRect)frame withStatusType:(StatusType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景遮盖
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        
        //弹窗背景图片
        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.backImageView.contentMode = UIViewContentModeScaleToFill;
        self.backImageView.layer.cornerRadius = 8;
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backImageView];
        
        //弹窗标题
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"发现有更好用的版本\n立即更新？";
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        self.titleLabel.textColor = kHexColor(0x666666);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backImageView addSubview:self.titleLabel];
        
        //选项按钮
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = kHexColor(0xD8D8D8);
        [self.cancelBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        [self.cancelBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn.layer.cornerRadius = kUnitHeight(20);
        [self.backImageView addSubview:self.cancelBtn];
        self.cancelBtn.enabled = NO;
        self.cancelBtn.tag = 1000;
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.frame = CGRectMake(kUnitWidth(20), kUnitHeight(190)-kUnitHeight(65)-kUnitHeight(14), kUnitWidth(250), kUnitHeight(14));
        self.progressView.progress = 0.0;
        self.progressView.layer.cornerRadius = kUnitHeight(7);
        self.progressView.layer.masksToBounds = YES;
        self.progressView.alpha = 1.0;
        self.progressView.trackTintColor = kHexColor(0xD8D8D8);
        self.progressView.backgroundColor = [UIColor clearColor];
        [self.backImageView addSubview:self.progressView];
        
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn.frame = CGRectMake(kUnitWidth(20) + kUnitWidth(115) + kUnitWidth(20), kUnitHeight(190) - kUnitHeight(21) - kUnitHeight(40), kUnitWidth(115), kUnitHeight(40));
        //Gradient 0 fill for 背景色
        CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
        gradientLayer0.frame = self.confirmBtn.bounds;
        gradientLayer0.colors = @[(id)kHexColor(0x3690FF).CGColor,
                                  (id)kHexColor(0x2C68FF).CGColor];
        gradientLayer0.locations = @[@0, @1];
        [gradientLayer0 setStartPoint:CGPointMake(0, 1)];
        [gradientLayer0 setEndPoint:CGPointMake(1, 1)];
        [self.confirmBtn.layer addSublayer:gradientLayer0];
        [self.confirmBtn setTitle:@"更新" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
        self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.size.height * 0.5;
        self.confirmBtn.layer.masksToBounds = YES;
        [self.confirmBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        [self.confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:self.confirmBtn];
        self.confirmBtn.tag = 1001;
     
        self.statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusBtn.frame = CGRectMake(kUnitWidth(36), kUnitHeight(190)-kUnitHeight(20)-kUnitHeight(45), kUnitWidth(218), kUnitHeight(45));
        CAGradientLayer *gradientLayer1 = [[CAGradientLayer alloc] init];
        gradientLayer1.frame = self.statusBtn.bounds;
        gradientLayer1.colors = @[(id)kHexColor(0x3690FF).CGColor,
                                  (id)kHexColor(0x2C68FF).CGColor];
        gradientLayer1.locations = @[@0, @1];
        [gradientLayer1 setStartPoint:CGPointMake(0, 1)];
        [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
        [self.statusBtn.layer addSublayer:gradientLayer1];
        [self.statusBtn setTitle:@"好的" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kHexColor(0xFFFFFF) forState:UIControlStateNormal];
        [self.statusBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        self.statusBtn.layer.cornerRadius = self.statusBtn.frame.size.height * 0.5;
        self.statusBtn.layer.masksToBounds = YES;
        [self.backImageView addSubview:self.statusBtn];
        self.statusBtn.tag = 1002;
        [self.statusBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@kUnitHeight(189));
            make.width.equalTo(@kUnitWidth(290));
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@43);
            make.right.equalTo(@0);
            make.height.equalTo(@kUnitHeight(43));
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@kUnitWidth(20));
            make.right.equalTo(@kUnitWidth(-20));
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(kUnitHeight(30));
            make.height.equalTo(@kUnitHeight(14));
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@kUnitWidth(20));
            make.top.equalTo(@(kUnitHeight(150) - kUnitHeight(20)));
            make.height.equalTo(@kUnitHeight(40));
            make.width.equalTo(@kUnitWidth(115));
        }];
        
        self.progressView.hidden = NO;
        self.statusBtn.hidden = YES;
        self.cancelBtn.hidden = NO;
        self.confirmBtn.hidden = NO;
    }
    return self;
}
-(void)updateProgress:(double)progress
{
    if (progress >= 1) {
        progress = 1;
        // 下载完毕
        self.titleLabel.text = [NSString stringWithFormat:@"版本更新中(%.0f%%)",progress*100];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 1.0;
            if (self.gradientLayer)
            {
                [self.gradientLayer removeFromSuperlayer];
            }
            self.gradientLayer = [[CAGradientLayer alloc] init];
            self.gradientLayer.frame = CGRectMake(0, 0, kUnitHeight(250)* self.progressView.progress, kUnitHeight(14));
            self.gradientLayer.colors = @[(id)kHexColor(0x3690FF).CGColor,
                                          (id)kHexColor(0x2C68FF).CGColor];
            self.gradientLayer.locations = @[@0, @1];
            [self.gradientLayer setStartPoint:CGPointMake(0, 1)];
            [self.gradientLayer setEndPoint:CGPointMake(self.progressView.progress, 1)];
            [self.progressView.layer addSublayer:self.gradientLayer];
            self.progressView.hidden = YES;
            [self.progressView removeFromSuperview];
            self.progressView = nil;
            self.statusBtn.hidden = NO;
            self.titleLabel.text = @"更新成功,立即体验吧";
            self.cancelBtn.hidden = YES;
            self.confirmBtn.hidden = YES;
        });
    
    } else
    {
        if (self.progressView)
        {
            self.cancelBtn.hidden = YES;
            self.confirmBtn.hidden = YES;
            self.progressView.hidden = NO;
            self.progressView.progress =  progress;
            self.titleLabel.text = [NSString stringWithFormat:@"版本更新中(%.0f%%)",progress*100];
            if (self.gradientLayer)
            {
                [self.gradientLayer removeFromSuperlayer];
            }
            self.gradientLayer = [[CAGradientLayer alloc] init];
            self.gradientLayer.frame = CGRectMake(0, 0, kUnitHeight(250)* self.progressView.progress, kUnitHeight(14));
            self.gradientLayer.colors = @[(id)kHexColor(0x3690FF).CGColor,
                                          (id)kHexColor(0x2C68FF).CGColor];
            self.gradientLayer.locations = @[@0, @1];
            [self.gradientLayer setStartPoint:CGPointMake(0, 1)];
            [self.gradientLayer setEndPoint:CGPointMake(self.progressView.progress, 1)];
            [self.progressView.layer addSublayer:self.gradientLayer];
        }
    }
}
-(void)showError
{
     self.titleLabel.text = @"更新出了点问题，请再试试~";
    self.progressView.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.confirmBtn.hidden = YES;
    self.statusBtn.hidden = NO;
    [self.statusBtn setTitle:@"再次更新" forState:UIControlStateNormal];
}
-(void)confirmClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didSelectOptionButtonWithTag:)]) {
        [_delegate alertView:self didSelectOptionButtonWithTag:sender.tag];
    }
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}
@end
