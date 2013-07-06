//
//  AppDelegate.m
//  shorrt
//
//  Created by Alexander Solovyov on 3/3/13.
//
//

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.isVisible = NO;
    [self parseAndProcessConfig];
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
    NSArray * bits = [desc componentsSeparatedByString:@"-"];

    unsigned short key = [self idForKey:[bits lastObject]];

    NSUInteger modifiers = 0;
    for (int i = 0; i < ([bits count] - 1); i++) {
        modifiers = modifiers | [self modifierByName:[bits objectAtIndex:i]];
    }

//    NSLog(@"registering %d mod %ld (%@) for %@", key,
//          (unsigned long)modifiers, desc, action);

    DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
    [c registerHotKeyWithKeyCode:key
                   modifierFlags:modifiers
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

- (NSUInteger)modifierByName:(NSString *)name {
    NSDictionary * mods = @{@"shift": [NSNumber numberWithInteger:NSShiftKeyMask],
                            @"ctrl": [NSNumber numberWithInteger:NSControlKeyMask],
                            @"alt": [NSNumber numberWithInteger:NSAlternateKeyMask],
                            @"cmd": [NSNumber numberWithInteger:NSCommandKeyMask]};
    NSNumber * result = mods[name];
    return [result integerValue];
}

- (unsigned short)idForKey:(NSString *)key {
    NSDictionary * aliases = @{@"'": @"quote"};

    if ([aliases objectForKey:key])
        key = [aliases objectForKey:key];

    NSDictionary * keys = @{@"a": [NSNumber numberWithInteger:0x00],
                            @"s": [NSNumber numberWithInteger:0x01],
                            @"d": [NSNumber numberWithInteger:0x02],
                            @"f": [NSNumber numberWithInteger:0x03],
                            @"h": [NSNumber numberWithInteger:0x04],
                            @"g": [NSNumber numberWithInteger:0x05],
                            @"z": [NSNumber numberWithInteger:0x06],
                            @"x": [NSNumber numberWithInteger:0x07],
                            @"c": [NSNumber numberWithInteger:0x08],
                            @"v": [NSNumber numberWithInteger:0x09],
                            @"b": [NSNumber numberWithInteger:0x0B],
                            @"q": [NSNumber numberWithInteger:0x0C],
                            @"w": [NSNumber numberWithInteger:0x0D],
                            @"e": [NSNumber numberWithInteger:0x0E],
                            @"r": [NSNumber numberWithInteger:0x0F],
                            @"y": [NSNumber numberWithInteger:0x10],
                            @"t": [NSNumber numberWithInteger:0x11],
                            @"1": [NSNumber numberWithInteger:0x12],
                            @"2": [NSNumber numberWithInteger:0x13],
                            @"3": [NSNumber numberWithInteger:0x14],
                            @"4": [NSNumber numberWithInteger:0x15],
                            @"6": [NSNumber numberWithInteger:0x16],
                            @"5": [NSNumber numberWithInteger:0x17],
                            @"equal": [NSNumber numberWithInteger:0x18],
                            @"9": [NSNumber numberWithInteger:0x19],
                            @"7": [NSNumber numberWithInteger:0x1A],
                            @"minus": [NSNumber numberWithInteger:0x1B],
                            @"8": [NSNumber numberWithInteger:0x1C],
                            @"0": [NSNumber numberWithInteger:0x1D],
                            @"rightbracket": [NSNumber numberWithInteger:0x1E],
                            @"o": [NSNumber numberWithInteger:0x1F],
                            @"u": [NSNumber numberWithInteger:0x20],
                            @"leftbracket": [NSNumber numberWithInteger:0x21],
                            @"i": [NSNumber numberWithInteger:0x22],
                            @"p": [NSNumber numberWithInteger:0x23],
                            @"l": [NSNumber numberWithInteger:0x25],
                            @"j": [NSNumber numberWithInteger:0x26],
                            @"quote": [NSNumber numberWithInteger:0x27],
                            @"k": [NSNumber numberWithInteger:0x28],
                            @"semicolon": [NSNumber numberWithInteger:0x29],
                            @"backslash": [NSNumber numberWithInteger:0x2A],
                            @"comma": [NSNumber numberWithInteger:0x2B],
                            @"slash": [NSNumber numberWithInteger:0x2C],
                            @"n": [NSNumber numberWithInteger:0x2D],
                            @"m": [NSNumber numberWithInteger:0x2E],
                            @"period": [NSNumber numberWithInteger:0x2F],
                            @"grave": [NSNumber numberWithInteger:0x32],
                            @"keypaddecimal": [NSNumber numberWithInteger:0x41],
                            @"keypadmultiply": [NSNumber numberWithInteger:0x43],
                            @"keypadplus": [NSNumber numberWithInteger:0x45],
                            @"keypadclear": [NSNumber numberWithInteger:0x47],
                            @"keypaddivide": [NSNumber numberWithInteger:0x4B],
                            @"keypadenter": [NSNumber numberWithInteger:0x4C],
                            @"keypadminus": [NSNumber numberWithInteger:0x4E],
                            @"keypadequals": [NSNumber numberWithInteger:0x51],
                            @"keypad0": [NSNumber numberWithInteger:0x52],
                            @"keypad1": [NSNumber numberWithInteger:0x53],
                            @"keypad2": [NSNumber numberWithInteger:0x54],
                            @"keypad3": [NSNumber numberWithInteger:0x55],
                            @"keypad4": [NSNumber numberWithInteger:0x56],
                            @"keypad5": [NSNumber numberWithInteger:0x57],
                            @"keypad6": [NSNumber numberWithInteger:0x58],
                            @"keypad7": [NSNumber numberWithInteger:0x59],
                            @"keypad8": [NSNumber numberWithInteger:0x5B],
                            @"keypad9": [NSNumber numberWithInteger:0x5C]
                            };

    NSNumber * result = [keys objectForKey:[key lowercaseString]];
    return [result integerValue];
}

@end
