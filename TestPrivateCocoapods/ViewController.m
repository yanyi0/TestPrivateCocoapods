//
//  ViewController.m
//  TestPrivateCocoapods
//
//  Created by Cloud on 2018/7/27.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import "ViewController.h"

#define MP3URL @"https://cdn.xhqb.com/music/mp3_xh/1001_url.mp3"
#define VideoUrl @"https://video.shuanaer.com/sv/21f90151-163bf5128ea/21f90151-163bf5128ea.mp4"
@interface ViewController ()<BCAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    self.alertView = [[BCAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds withStatusType:HotUpdatingStatus];
    self.alertView.delegate = self;
    self.hotUpdateUrl = VideoUrl;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)alertView:(BCAlertView *)alertView didSelectOptionButtonWithTag:(NSInteger)tag
{
    if (tag == 1001) {
        [[DYDownloadTool shared] downLoadWithUrl:self.hotUpdateUrl withAlertView:alertView];
    }
    else if(tag == 1002)
    {
        UIButton *btn = [alertView viewWithTag:tag];
        if ([btn.titleLabel.text isEqualToString:@"好的"]) {
            [alertView dismiss];
        }
        else if([btn.titleLabel.text isEqualToString:@"再次更新"])
        {
            [[DYDownloadTool shared] downLoadWithUrl:self.hotUpdateUrl withAlertView:alertView];
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.alertView show];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
