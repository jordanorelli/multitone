//
//  OSCDemoViewController.m
//  OSCDemo
//
//  Created by georg on 12/04/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "OSCDemoViewController.h"
#import "VVOSC.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation OSCDemoViewController


#define frequency 0.2


-(void)tune:(int)i
{
    int v = 1;
	OSCMessage *ip = [OSCMessage createWithAddress:[@"/pitchtoggle/" stringByAppendingFormat:@"%d/%d", v, i]];
    [ip addFloat:1.0];    
	[outPort2 sendThisPacket:[OSCPacket createWithContent:ip]];  
}
-(void)waveform:(int)i
{
    int v = 1;
	OSCMessage *ip = [OSCMessage createWithAddress:[@"/waveToggle/" stringByAppendingFormat:@"%d/%d",v, i]];
    [ip addFloat:1.0];    
	[outPort2 sendThisPacket:[OSCPacket createWithContent:ip]];  
    
}
-(void)circle:(float)x :(float)y :(int)index
{

    NSString *path=[@"/voice/" stringByAppendingFormat:@"%d", index];
	OSCMessage *ip = [OSCMessage createWithAddress:path];
    [ip addFloat:x];
    [ip addFloat:y];
    [ip addFloat:slider.value];
    [ip addInt:0];
    
	[outPort sendThisPacket:[OSCPacket createWithContent:ip]];  
}
-(void)sound:(float)x :(float)y :(int)index
{

    NSString *path=[@"/multixy/" stringByAppendingFormat:@"%d", index];
	OSCMessage *ip2 = [OSCMessage createWithAddress:path];
    [ip2 addFloat:y];
    [ip2 addFloat:x];
    
	[outPort2 sendThisPacket:[OSCPacket createWithContent:ip2]];  
}
-(void)sendNote:(float)x :(float)y :(int)index
{
    [self sound:x :y :index];
    [self circle:x :y :index];
}




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
	
    touches = [[NSMutableArray alloc] initWithCapacity:10];
	// OSC 
	manager = [[OSCManager alloc] init];
	[manager setDelegate:self];
    
    sendingToIP2 = @"192.168.1.4";
	sendingToPort2 = 9000;
    outPort2 = [manager createNewOutputToAddress:sendingToIP2 atPort:sendingToPort2];


    sendingToIP = @"192.168.1.6";
	sendingToPort = 9001;
	outPort = [manager createNewOutputToAddress:sendingToIP atPort:sendingToPort];
    playing = NO;
	
    
	// receiving
	receivingOnPort = 51234;
	//inPort = [manager createNewInput]; // default at port 1234
	inPort = [manager createNewInputForPort:receivingOnPort];
	S = 88;
	
	UIView *top = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.height -20, S)];
    top.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [self.view addSubview:top];
	// View
	
	self.view.backgroundColor = [UIColor blackColor];
	self.view.userInteractionEnabled = YES;
	self.view.multipleTouchEnabled = YES;
    
    tuning1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tuning1.frame = CGRectMake(0, 0, S,S);
    [tuning1 addTarget:self action:@selector(setTune:) forControlEvents:UIControlEventTouchUpInside];
    tuning1.backgroundColor = [UIColor blueColor];
    [top addSubview:tuning1];
    
    
    tuning2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tuning2 addTarget:self action:@selector(setTune:) forControlEvents:UIControlEventTouchUpInside];
    tuning2.frame = CGRectMake(10+S, 0, S,S);
    tuning2.backgroundColor = [UIColor blueColor];
    [top addSubview:tuning2];

    [self setTune:tuning1];
    waveform1 = [UIButton buttonWithType:UIButtonTypeCustom];
    waveform1.frame = CGRectMake(2*(10+S), 0,S,S);
    [waveform1 addTarget:self action:@selector(setWaveform:) forControlEvents:UIControlEventTouchUpInside];
    waveform1.backgroundColor = [UIColor redColor];
    [top addSubview:waveform1];
    
    
    waveform2 = [UIButton buttonWithType:UIButtonTypeCustom];
    waveform2.frame = CGRectMake(3*(10+S), 0, S,S);
    [waveform2 addTarget:self action:@selector(setWaveform:) forControlEvents:UIControlEventTouchUpInside];
    waveform2.backgroundColor = [UIColor redColor];
    [top addSubview:waveform2];
    
    waveform3 = [UIButton buttonWithType:UIButtonTypeCustom];
    waveform3.frame = CGRectMake(4*(10+S), 0, S,S);
    [waveform3 addTarget:self action:@selector(setWaveform:) forControlEvents:UIControlEventTouchUpInside];
    waveform3.backgroundColor = [UIColor redColor];
    [top addSubview:waveform3];

    waveform4 = [UIButton buttonWithType:UIButtonTypeCustom];
    waveform4.frame = CGRectMake(5*(10+S), 0, S, S);
    [waveform4 addTarget:self action:@selector(setWaveform:) forControlEvents:UIControlEventTouchUpInside];
    waveform4.backgroundColor = [UIColor redColor];
    [top addSubview:waveform4];

    [self setWaveform:waveform1];
    
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(10+6*(10+S),10, self.view.frame.size.height-6*(10+S)-10, S)];
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(sliderMove:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderStart:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setTune:(UIButton*)sender
{
    UIColor *blue=[UIColor colorWithRed:0 green:0 blue:0.25 alpha:1];

    tuning1.backgroundColor = blue;
    tuning2.backgroundColor = blue;
    sender.backgroundColor = [UIColor blueColor];
    
    
    if(sender == tuning1)
    {
        [self tune:1];
    }
    if(sender == tuning2)
    {
        [self tune:2];
        
    }
}

-(void)setWaveform:(UIButton*)sender
{
    UIColor *red=[UIColor colorWithRed:0.25 green:0 blue:0 alpha:1];
    waveform1.backgroundColor = red;
    waveform2.backgroundColor = red;
    waveform3.backgroundColor = red;
    waveform4.backgroundColor = red;

    sender.backgroundColor = [UIColor redColor];

    if(sender == waveform1)
    {
        [self waveform:1];
    }
    if(sender == waveform2)
    { 
        [self waveform:2];
    }
    if(sender == waveform3)
    {
        [self waveform:3];
    }
    if(sender == waveform4)
    {  
        [self waveform:4];
    }

}

- (void) sliderStart:(UISlider*)slider
{

}

- (void) sliderEnd:(UISlider*)slider 
{

}

- (void) sliderMove:(UISlider*)inSlider 
{
    
    OSCMessage *ip = [OSCMessage createWithAddress:@"/reverbMix"];
    [ip addFloat:inSlider.value];        
	[outPort2 sendThisPacket:[OSCPacket createWithContent:ip]];  

}




// called by delegate on message
- (void) receivedOSCMessage:(OSCMessage *)m	
{	
	
	NSString *address = [m address];
	OSCValue *value = [m value];
	NSString *message;

	if ([address isEqualToString:@"/mouseX"]) 
    {
		message = [NSString stringWithFormat:@"mouseX: %i", [value intValue]];
		NSString *txt = [NSString stringWithFormat:@"%i", [value intValue]];
		//[receivingDataLabel performSelectorOnMainThread:@selector(setText:) withObject:txt waitUntilDone:NO];
		
	} else if ([address isEqualToString:@"/mouseY"])
    {
		message = [NSString stringWithFormat:@"mouseY: %i", [value intValue]];
	} else if ([address isEqualToString:@"/floatArray"])
    {
		message = [NSString stringWithFormat:@"floatArray: %f", [value floatValue]];
	}
	
	NSLog(@"%@: %@", address, value);
}

- (void)sendOSCMessage:(float)floatMessage label:(NSString*)label
{
	OSCMessage *msg = [OSCMessage createWithAddress:label];
	[msg addFloat:floatMessage];
	[outPort sendThisPacket:[OSCPacket createWithContent:msg]];
}






-(NSString *) getMyWifiIP 
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) 
    {
		cursor = addrs;
		while (cursor != NULL)
        {
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) // this second test keeps from picking up the loopback address
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) 
                { // found the WiFi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
				}
			}
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return NULL;
}



-(void)playNote
{
    for(UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInView:self.view];
        
        
        X = loc.x / self.view.frame.size.height;
        Y = 1.0-((loc.y-S) / (self.view.frame.size.width-S));

        [self sendNote:X :Y :[touches indexOfObject:touch]];
    }   

    
    if(playing)
    {
        playing = YES;
        [self performSelector:@selector(playNote) withObject:self afterDelay:0.02];        
    }
}
-(void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)event
{
    playing=YES;
    
    for(UITouch *touch in inTouches)
        [touches addObject:touch];
    
    [self playNote];   
}

/*
-(void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)event
{
    [touches removeAllObjects];
    for(UITouch *touch in inTouches)
        [touches addObject:touch];
    
    
}*/
-(void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)event
{

    for(UITouch *touch in inTouches)
        [touches removeObject:touch];
    
    if([touches count]==0)
    {
        playing = NO;
    }

}
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
             (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)dealloc 
{
	[manager setDelegate:nil];
	[manager release];
    [super dealloc];
}

@end
