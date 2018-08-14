//
//  NetworkUtility.h
//  hush
//
//  Created by Pradeep Gali on 08/11/14.
//  Copyright (c) 2014 Pradeep Gali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface NetworkUtility : NSObject {
    AVAudioPlayer *audioPlayer;
    BOOL enabled;
}

@property (strong, nonatomic) id someProperty;

- (void) someMethod;

- (NSString *) GetCurrentWifiHotSpotName;

- (void) silentPhone;

- (void) unsilencePhone;
- (void) initListner;

- (void) pluginInitialize;
- (void) keepAwake;
- (void) stopKeepingAwake;

@end
