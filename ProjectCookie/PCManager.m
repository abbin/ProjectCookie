//
//  PCManager.m
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "PCManager.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

NSString *const kBPAppLocation = @"appLocation";

@implementation PCManager

+(BOOL)isLocationSet{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kBPAppLocation]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(UIColor*)mainColor{
    return UIColorFromRGB(0xF44336);
}

@end
