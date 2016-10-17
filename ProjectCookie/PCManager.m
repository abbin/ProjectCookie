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

NSString *const kPCAppLocation  = @"appLocation";
NSString *const kPCUserName     = @"userName";
NSString *const kPCUserImage    = @"userimage";

@implementation PCManager

+(BOOL)isLocationSet{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kPCAppLocation]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(UIColor*)mainColor{
    return UIColorFromRGB(0xF44336);
}

+ (instancetype)sharedManager {
    static PCManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    return self;
}

+(void)initUser{
    CKContainer *container = [CKContainer defaultContainer];
    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
       [[container publicCloudDatabase] fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
           if (!error && [PCManager sharedManager].currectUser == nil) {
               [PCManager sharedManager].currectUser = record;
           }
       }];
    }];
}

+(void)updateUser{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kPCUserName];
    NSURL *url = [[NSUserDefaults standardUserDefaults] URLForKey:kPCUserImage];
    
    if (userName.length>0 && url && [PCManager sharedManager].currectUser) {
        [PCManager sharedManager].currectUser[kPCUserName] = userName;
        
        CKAsset *asset = [[CKAsset alloc] initWithFileURL:url];
        [PCManager sharedManager].currectUser[kPCUserImage] = asset;
        
        CKContainer *myContainer = [CKContainer defaultContainer];
        CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
        
        [publicDatabase saveRecord:[PCManager sharedManager].currectUser completionHandler:^(CKRecord *artworkRecord, NSError *error){
            if (!error) {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault removeObjectForKey:kPCUserName];
                [userDefault removeObjectForKey:kPCUserImage];
                [userDefault synchronize];

                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error;
                BOOL success = [fileManager removeItemAtURL:url error:&error];
                if (success) {
                    NSLog(@"Removed file");
                }
                else{
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
            }
        }];
    }
}

@end
