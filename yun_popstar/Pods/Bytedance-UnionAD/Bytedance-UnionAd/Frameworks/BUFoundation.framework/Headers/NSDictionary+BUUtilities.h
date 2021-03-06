//
//  NSMutableDictionary+Utilities.h
//  BUAdSDK
//
//  Created by 李盛 on 2018/2/28.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BU_Helper)

- (BOOL)bu_isNull:(id)value;
- (instancetype)bu_objectForKeySafely:(id)aKey;
- (instancetype)bu_valueForKeySafely:(NSString *)key;
- (instancetype)bu_valueForKeyPathSafely:(NSString *)keyPath;

#pragma mark - Safe Value Type From Key
- (NSString *)bu_stringForKey:(NSString *)key defaultValue:(NSString *)defalutValue;
- (NSInteger)bu_integerForKey:(NSString *)key defaultValue:(NSInteger)defalutValue;
- (NSTimeInterval)bu_timeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)defalutValue;
- (NSArray *)bu_arrayForKey:(NSString *)key defaultValue:(NSArray *)defalutValue;
- (NSDictionary *)bu_dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defalutValue;
@end

@interface NSDictionary(BU_JSONValue)

- (NSString *)bu_JSONRepresentation:(NSError **)error;
+ (id)bu_dictionaryWithJSONData:(NSData *)inData error:(NSError **)outError;
+ (id)bu_dictionaryWithJSONString:(NSString *)inJSON error:(NSError **)outError;
@end
