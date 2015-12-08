//
//  MainBtn.h
//  MPKX
//
//  Created by zzwu on 15/11/20.
//  Copyright © 2015年 zzwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainBtn : NSObject

@property(nonatomic,copy) NSString *icon;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)mainBtnWithDict:(NSDictionary *)dict;

@end
