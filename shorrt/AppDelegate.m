//
//  AppDelegate.m
//  shorrt
//
//  Created by Alexander Solovyov on 3/3/13.
//
//

#import "AppDelegate.h"
#import "ASHotKeyCenter.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.isVisible = NO;
    [self parseAndProcessConfig];

    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
}

// in case when you try to launch app second time, its window becomes visible
- (void)applicationWillBecomeActive:(NSNotification *)notification {
    self.window.isVisible = YES;
}

#pragma mark - Config stuff

- (void)parseAndProcessConfig {
    NSString * path = [@"~/.shorrt" stringByExpandingTildeInPath];
    NSString * body = [NSString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
    [body enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        NSArray * bits = [line componentsSeparatedByString:@"="];
        [self registerHotkey:[self trimWS:bits[0]]
                   forAction:[self trimWS:bits[1]]];
    }];
}

- (void)registerHotkey:(NSString *)desc forAction:(NSString *)action {
    ASHotKeyCenter* c = [ASHotKeyCenter sharedHotKeyCenter];

    [c registerHotKey:desc
               target:self
               action:@selector(hotkeyWithEvent:object:)
               object:action];
}

#pragma mark - Hotkey reaction

- (void)hotkeyWithEvent:(NSEvent *)event object:(NSString *)params {
    NSArray * bits = [params componentsSeparatedByString:@":"];
    NSString * action = [self trimWS:bits[0]];
    NSString * payload = [self trimWS:bits[1]];

    if ([action isEqualToString:@"app"])
        [[NSWorkspace sharedWorkspace] launchApplication:payload];
    else
        NSLog(@"Unknown action: %@ with payload: %@", action, payload);
}

#pragma mark - Utility

- (NSString *)trimWS:(NSString *)input {
    return [input
            stringByTrimmingCharactersInSet:[NSCharacterSet
                                             whitespaceAndNewlineCharacterSet]];
}

@end
