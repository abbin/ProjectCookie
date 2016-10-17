//
//  PCAppLocationViewController.m
//  ProjectCookie
//
//  Created by Abbin Varghese on 17/10/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "PCAppLocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PCManager.h"
#import <CoreLocation/CoreLocation.h>

@interface PCAppLocationViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (weak, nonatomic) IBOutlet UIButton *autoDectectButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL firstUpdateFinished;

@end

@implementation PCAppLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_0102" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.playerView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.autoDectectButton setTintColor:[UIColor whiteColor]];
    [self.autoDectectButton setBackgroundColor:[PCManager mainColor]];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.avplayer play];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying{
    [self.avplayer play];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)autoDetectLocation:(id)sender {
    [self requestLocationServicesAuthorization];
}

- (IBAction)manuallyDetectLocation:(id)sender {
    
}

- (void)requestLocationServicesAuthorization {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    /*
     Gets user permission to get their location while the app is in the foreground.
     
     To monitor the user's location even when the app is in the background:
     1. Replace [self.locationManager requestWhenInUseAuthorization] with [self.locationManager requestAlwaysAuthorization]
     2. Change NSLocationWhenInUseUsageDescription to NSLocationAlwaysUsageDescription in InfoPlist.strings
     */
    [self.locationManager requestWhenInUseAuthorization];
    
    /*
     Requests a single location after the user is presented with a consent dialog.
     */
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.firstUpdateFinished) {
        self.firstUpdateFinished = YES;
        [self.locationManager stopUpdatingLocation];
        
        CLLocation *currentLocation = [locations firstObject];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                [[NSUserDefaults standardUserDefaults] setObject:placemark.addressDictionary forKey:kBPAppLocation];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}


@end
