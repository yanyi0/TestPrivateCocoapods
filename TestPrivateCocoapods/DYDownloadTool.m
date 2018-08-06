//
//  DYDownloadTool.m
//  TestPrivateCocoapods
//
//  Created by Cloud on 2018/8/6.
//  Copyright © 2018年 Cloud. All rights reserved.
//

#import "DYDownloadTool.h"
#import "AFURLSessionManager.h"
#import "ViewController.h"
static DYDownloadTool *_sharedInstance = nil;
@implementation DYDownloadTool
/*!
 *  @brief 获得单实例方法
 */
+ (DYDownloadTool *)shared {
    //第二步：实例构造检查静态实例是否为nil
    @synchronized(self) {
        if (_sharedInstance == nil) {
            [self new];
        }
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone //第四步
{
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)deleteAllContent:(NSString *)path
{
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *fileName;
    while (fileName= [dirEnum nextObject]) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
    }
}
-(void)downLoadWithUrl:(NSString*)url withAlertView:(BCAlertView *)alertView
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bundlePath = [documentsPath stringByAppendingPathComponent:@"IOSBundle"];
    NSLog(@"333333333333333333333%@",bundlePath);
    //是否存在文件夹IOSBundle，不存在则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:bundlePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //下载之前先删除document路径下IOSBundle下面所有内容
    [self deleteAllContent:bundlePath];
    
    //根据URL下载相关文件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSProgress *downloadProgress = nil;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&downloadProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //有返回值的block，返回文件存储路径
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* localPackageDir;
        localPackageDir = [documentPath stringByAppendingPathComponent:@"IOSBundle"];
        //不存在目录Bundle,创建目录
        //是否存在文件夹IOSBundle，不存在则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPackageDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localPackageDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *path = [localPackageDir stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"目标Url:%@,%@",path,[response suggestedFilename]);
        self.fileName = response.suggestedFilename;
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"filePath:%@,%@",filePath,filePath.absoluteString);
        //下载完成移除观察者模式
        [downloadProgress removeObserver:self forKeyPath:@"fractionCompleted"];
        //下载失败
        if (error)
        {
            [alertView showError];
            NSLog(@"%@",error.localizedDescription);
        }
        else//下载成功
        {
            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
            NSString *bundleFilePath = [filePath path];// 将NSURL转成NSString
            NSLog(@"FilePath = %@",bundleFilePath);
            NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *destinationPath;
            destinationPath = [[documentArray lastObject] stringByAppendingPathComponent:@"IOSBundle"];
            //保存解压后的路径
            self.filePath = bundleFilePath;
//            [self releaseZipFilesWithUnzipFileAtPath:bundleFilePath Destination:destinationPath];
        }
    }];
    //KVO观察下载进度
    [downloadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    //开始下载
    [downloadTask resume];
}
#pragma mark - 拿到进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //拿到进度
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress is %f", progress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            ViewController *topViewController = (ViewController *)[self getTopViewController];
             [topViewController.alertView updateProgress:progress.fractionCompleted];
        });
    }
}
// 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",unzipPath);
    }else {
        NSLog(@"%@",error);
    }
}
#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"将要解压。");
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath;
{
    NSLog(@"%@,%@",[NSThread currentThread],path);
    NSLog(@"解压完成！");
}
-(UIViewController *)getTopViewController {
    UIViewController *resultVC;
    resultVC = [self searchTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self searchTopViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
-(UIViewController *)searchTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self searchTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self searchTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
