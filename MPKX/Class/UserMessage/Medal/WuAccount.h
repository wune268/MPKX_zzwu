//
//  WuAccount.h
//  MPKX
//
//  Created by zzwu on 15/12/3.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WuAccount : NSObject<NSCoding>

@property (nonatomic, copy) NSString *token;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
