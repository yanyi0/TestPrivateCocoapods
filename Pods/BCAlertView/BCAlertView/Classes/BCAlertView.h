//
//  BCAlertView.h
//
//  Created by cloud on 2018/6/11.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    HotUpdateStatus = 0,
    HotUpdatingStatus = 1,
    HotUpdateSuccess = 2,
    HotUpdateFail = 3,
} StatusType;
@class BCAlertView;
@protocol BCAlertViewDelegate <NSObject>
-(void)alertView:(BCAlertView *)alertView didSelectOptionButtonWithTag:(NSInteger)tag;
@end
@interface BCAlertView : UIView
@property (nonatomic, weak) id<BCAlertViewDelegate> delegate;
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)UIButton *statusBtn;
- (id)initWithFrame:(CGRect)frame withStatusType:(StatusType)type;
-(void)updateProgress:(CGFloat)progressValue;
-(void)showError;
-(void)show;
-(void)dismiss;
@end
