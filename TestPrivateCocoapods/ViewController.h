//
//  ViewController.h
//  TestPrivateCocoapods
//
//  Created by Cloud on 2018/7/27.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCAlertView.h"
#import "NSObject+runtime.h"
#import "DYDownloadTool.h"
@interface ViewController : UIViewController
@property(nonatomic,copy)NSString *hotUpdateUrl;
@property(strong,nonatomic)BCAlertView *alertView;
@end

