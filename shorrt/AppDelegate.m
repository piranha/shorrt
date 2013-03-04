//
//  AppDelegate.m
//  shorrt
//
//  Created by Alexander Solovyov on 3/3/13.
//
//

#import "AppDelegate.h"

FourCharCode kShorrtSignature = 'WBUL';
NSString *const iTunesShortcut = @"iTunesShortcut";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.isVisible = NO;
    [self handleHotkeys];
    [self registerHotkey];
}

// in case when you try to launch app second time, its window becomes visible
- (void)applicationWillBecomeActive:(NSNotification *)notification {
    self.window.isVisible = YES;
}

static EventHandlerRef sEventHandler = NULL;

- (OSStatus)handleHotkeys {
    EventTypeSpec hkpressed = { .eventClass = kEventClassKeyboard,
        .eventKind = kEventHotKeyPressed };
    OSStatus err = InstallEventHandler(GetEventDispatcherTarget(),
                                       CarbonCallback, 1,
                                       &hkpressed, NULL, &sEventHandler);

    if (err != noErr) {
        sEventHandler = NULL;
    }
    return err;
}

- (OSStatus)registerHotkey {
    EventHotKeyID hkid = {.signature = kShorrtSignature, .id = 1};
    EventHotKeyRef hkref;

    OSStatus err = RegisterEventHotKey(34,
                                       cmdKey + controlKey,
                                       hkid,
                                       GetEventDispatcherTarget(),
                                       0,
                                       &hkref);

    return err;
}

static OSStatus CarbonCallback(EventHandlerCallRef inHandlerCallRef,
                               EventRef inEvent, void *inUserData) {
    [[NSWorkspace sharedWorkspace] launchApplication:@"iTunes"];
    return noErr;
}

@end
