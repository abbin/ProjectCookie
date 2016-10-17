//
//  ViewController.m
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>
#import "PCManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![PCManager isLocationSet]) {
        CKContainer *myContainer = [CKContainer defaultContainer];
        [myContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
            [[myContainer publicCloudDatabase] fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
            }];
        }];
    }
}


@end
