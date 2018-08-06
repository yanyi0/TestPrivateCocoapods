//
//  DYDownloadTool.h
//  TestPrivateCocoapods
//
//  Created by Cloud on 2018/8/6.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCAlertView.h"
#import "SSZipArchive.h"
@interface DYDownloadTool : NSObject<SSZipArchiveDelegate>
+(DYDownloadTool *)shared;
#pragma 获取最顶层控制器
- (UIViewController *)getTopViewController;
@property(nonatomic,copy)NSString *bundlePath;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *filePath;
//根据url下载相关文件
-(void)downLoadWithUrl:(NSString*)url withAlertView:(BCAlertView *)alertView;
#pragma 获取最顶层控制器
- (UIViewController *)getTopViewController;
@end
