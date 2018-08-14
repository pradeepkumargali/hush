//
//  NetworkUtility.m
//  hush
//
//  Created by Pradeep Gali on 08/11/14.
//  Copyright (c) 2014 Pradeep Gali. All rights reserved.
//

#import "NetworkUtility.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"



@implementation NetworkUtility : NSObject

- (void) someMethod {
    NSLog(@"SomeMethod Ran");
}

- (NSString *)GetCurrentWifiHotSpotName {
    
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        //NSLog(@"info:%@",info);
        
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}

- (void) initListner{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    onNotifyCallback, // callback
                                    NULL, // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

static void onNotifyCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
   NSLog(@"Callback detected: \n\t name: %@ \n\t object:%@", name, object);
}

- (void) silentPhone{
    float newVolumeLevel=0;
    
    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];
    
    NSString *soundCategory = @"Ringtone";
    
    NSInvocation *volumeInvocation = [NSInvocation invocationWithMethodSignature:
                                      [avSystemControllerClass instanceMethodSignatureForSelector:
                                       @selector(setVolumeTo:forCategory:)]];
    [volumeInvocation setTarget:avSystemControllerInstance];
    [volumeInvocation setSelector:@selector(setVolumeTo:forCategory:)];
    [volumeInvocation setArgument:&newVolumeLevel atIndex:2];
    [volumeInvocation setArgument:&soundCategory atIndex:3];
    [volumeInvocation invoke];
    
    /*MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:0.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside]; */
}

- (void) unsilencePhone{
    
    float newVolumeLevel=1;
    
    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];
    
    NSString *soundCategory = @"Ringtone";
    
    NSInvocation *volumeInvocation = [NSInvocation invocationWithMethodSignature:
                                      [avSystemControllerClass instanceMethodSignatureForSelector:
                                       @selector(setVolumeTo:forCategory:)]];
    [volumeInvocation setTarget:avSystemControllerInstance];
    [volumeInvocation setSelector:@selector(setVolumeTo:forCategory:)];
    [volumeInvocation setArgument:&newVolumeLevel atIndex:2];
    [volumeInvocation setArgument:&soundCategory atIndex:3];
    [volumeInvocation invoke];
    
    /*MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:1.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside]; */
    
}

- (void) initReach
{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityForLocalWiFi];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
}

- (void) pluginInitialize
{
    //[self disable];
    [self configureAudioPlayer];
    [self configureAudioSession];
    //[self observeLifeCycle];
}

/**
 * Register the listener for pause and resume events.
 */
- (void) observeLifeCycle
{
    NSNotificationCenter* listener = [NSNotificationCenter defaultCenter];
    
    if (&UIApplicationDidEnterBackgroundNotification && &UIApplicationWillEnterForegroundNotification) {
        
        /*[listener addObserver:self
                     selector:@selector(keepAwake)
                         name:UIApplicationDidEnterBackgroundNotification
                       object:nil];
        
        [listener addObserver:self
                     selector:@selector(stopKeepingAwake)
                         name:UIApplicationWillEnterForegroundNotification
                       object:nil];
        
        [listener addObserver:self
                     selector:@selector(handleAudioSessionInterruption:)
                         name:AVAudioSessionInterruptionNotification
                       object:nil]; */
        
    } else {
        [self enable];
        [self keepAwake];
    }
}



#pragma mark -
#pragma mark Interface methods

/**
 * Enable the mode to stay awake
 * when switching to background for the next time.
 */
- (void) enable
{
    enabled = YES;
}

/**
 * Disable the background mode
 * and stop being active in background.
 */
- (void) disable
{
    enabled = NO;
    
    [self stopKeepingAwake];
}

#pragma mark -
#pragma mark Core methods

/**
 * Keep the app awake.
 */
- (void) keepAwake {
   // if (enabled) {
        [audioPlayer play];
    //}
}

/**
 * Let the app going to sleep.
 */
- (void) stopKeepingAwake {
    [audioPlayer pause];
}

/**
 * Configure the audio player.
 */
- (void) configureAudioPlayer {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"silent"
                                                     ofType:@"wav"];
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                         error:&error];
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } 
    // Silent
    audioPlayer.volume = 1;
    // Infinite
    audioPlayer.numberOfLoops = 100;
};

/**
 * Configure the audio session.
 */
- (void) configureAudioSession {
    AVAudioSession* session = [AVAudioSession
                               sharedInstance];
    
    // Play music even in background and dont stop playing music
    // even another app starts playing sound
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:NULL];
    
    [session setActive:YES error:NULL];
};

/**
 * Restart playing sound when interrupted by phone calls.
 */
- (void) handleAudioSessionInterruption:(NSNotification*)notification {
    [self keepAwake];
}


@end