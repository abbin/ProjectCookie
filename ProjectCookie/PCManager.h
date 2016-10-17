//
//  PCManager.h
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

FOUNDATION_EXPORT NSString *const kPCAppLocation;
FOUNDATION_EXPORT NSString *const kPCUserName;
FOUNDATION_EXPORT NSString *const kPCUserImage;

@interface PCManager : NSObject

@property (nonatomic, strong) CKRecord *currectUser;

+(BOOL)isLocationSet;

+(UIColor*)mainColor;

+ (instancetype)sharedManager;

+ (void)initUser;

+(void)updateUser;

@end
