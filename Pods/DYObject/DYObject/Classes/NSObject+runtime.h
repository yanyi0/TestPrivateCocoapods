//
//  NSObject+runtime.h
//  WebViewDemo
//
//  Created by fish on 2018/7/6.
//  Copyright © 2018年 ChinaNetCenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (runtime)
/* 获取对象的所有属性 */
+(NSArray *)getAllProperties;
/* 获取对象的所有方法 */
+(NSArray *)getAllMethods;
/* 获取对象的所有属性和属性内容 */
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj;
@end
