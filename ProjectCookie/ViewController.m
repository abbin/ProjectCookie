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
#import "PCAppLocationViewController.h"
#import "PCUserProfileViewController.h"

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
        PCAppLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PCAppLocationViewController"];
        [vc completionHandler:^{
            PCUserProfileViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"PCUserProfileViewController"];
            [vc2 completionHandler:^{
                
            }];
            [vc.navigationController pushViewController:vc2 animated:YES];
        }];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalTransitionStyle         = UIModalTransitionStyleCrossDissolve;
        nav.modalPresentationStyle       = UIModalPresentationOverCurrentContext;
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


@end
