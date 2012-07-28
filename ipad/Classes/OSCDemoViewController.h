//
//  OSCDemoViewController.h
//  OSCDemo
//
//  Created by georg on 12/04/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCManager, OSCInPort, OSCOutPort;

@interface OSCDemoViewController : UIViewController
{
	
	NSString *sendingToIP;
    NSString *sendingToIP2;
    
	int sendingToPort;
    int sendingToPort2;

	int receivingOnPort;
	
	BOOL slidingFlag;

    UIButton *tuning1;
    UIButton *tuning2;	
    UISlider *slider;
    
    UIButton *waveform1;
    UIButton *waveform2;	
    UIButton *waveform3;
    UIButton *waveform4;	
    
    
	OSCManager *manager;
	OSCInPort *inPort;
	OSCOutPort *outPort;
    
    OSCOutPort *outPort2;
    
    bool playing;
    
    float X, Y;
    
    float S;
    
    NSMutableArray *touches;
}

- (void)sendOSCMessage:(float)floatMessage label:(NSString*)label;
-(NSString *) getMyWifiIP;

@end

