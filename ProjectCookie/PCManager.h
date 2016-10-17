//
//  PCManager.h
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kBPAppLocation;

@interface PCManager : NSObject

+(BOOL)isLocationSet;

+(UIColor*)mainColor;

@end
