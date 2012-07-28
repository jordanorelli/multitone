//
//  OSCDemoAppDelegate.h
//  OSCDemo
//
//  Created by georg on 12/04/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCDemoViewController;

@interface OSCDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OSCDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OSCDemoViewController *viewController;

@end

