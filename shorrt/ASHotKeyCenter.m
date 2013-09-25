//
//  ASHotKeyCenter.m
//  shorrt
//
//  Created by Alexander Solovyov on 30/7/13.
//  Copyright (c) 2013 Alexander Solovyov. All rights reserved.
//

#import "ASHotKeyCenter.h"
#import <Carbon/Carbon.h>

#pragma mark - Single key

static NSDictionary* _modifiers;
static NSDictionary* _keyMapping;
static NSDictionary* _revKeyMapping;

@implementation ASKey {
    NSString* _stringified;
}

@synthesize code = _code;
@synthesize flags = _flags;

+ (ASKey *)fromNSString:(NSString *)key {
    ASKey* k = [ASKey new];

    NSArray * bits = [key componentsSeparatedByString:@"-"];

    k.code = [ASKey codeByKey:[bits lastObject]];
    k.flags = 0;

    for (int i = 0; i < ([bits count] - 1); i++) {
        k.flags = k.flags | [ASKey modifierByName:[bits objectAtIndex:i]];
    }

    return k;
}

+ (ASKey *)fromEvent:(NSEvent *)e {
    ASKey* k = [ASKey new];

    k.code = e.keyCode;
    k.flags = e.modifierFlags;

    return k;
}

+ (NSUInteger)modifierByName:(NSString *)name {
    NSNumber * result = [ASKey modifiers][name];
    return result.integerValue;
}


- (NSString *)stringify {
    if (!_stringified) {
        NSMutableArray* bits = [NSMutableArray array];
        for (NSString* name in @[@"shift", @"ctrl", @"alt", @"cmd"]) {
            if (self.flags & [ASKey modifierByName:name]) {
                [bits addObject:name];
            }
        }
        [bits addObject:[ASKey keyByCode:self.code]];

        _stringified = [bits componentsJoinedByString:@"-"];
    }
    return _stringified;
}

+ (unsigned short)codeByKey:(NSString *)key {
    NSDictionary * aliases = @{
        @"=": @"equal",
        @"-": @"minus",
        @"]": @"rightbracket",
        @"[": @"leftbracket",
        @"'": @"quote",
        @";": @"semicolon",
        @"\\": @"backslash",
        @",": @"comma",
        @"/": @"slash",
        @".": @"period",
        @"`": @"grave",
        @"enter": @"return"
    };

    if ([aliases objectForKey:key])
        key = [aliases objectForKey:key];

    NSNumber * result = [ASKey keyMapping][[key lowercaseString]];
    if (result == NULL) {
        NSLog(@"Unknown key: %@", key);
        return 255;
    }
    return result.integerValue;
}

+ (NSString *)keyByCode:(unsigned short)code {
    NSString * key = [ASKey revKeyMapping][[NSNumber numberWithInteger:code]];
    if (key == NULL)
        return @"UNKNOWN_KEY";
    return key;
}

#pragma mark Keys Definitions

+ (NSDictionary*)modifiers {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _modifiers = @{@"shift": [NSNumber numberWithInteger:NSShiftKeyMask],
                       @"ctrl": [NSNumber numberWithInteger:NSControlKeyMask],
                       @"alt": [NSNumber numberWithInteger:NSAlternateKeyMask],
                       @"cmd": [NSNumber numberWithInteger:NSCommandKeyMask]};
    });
    return _modifiers;
}

+ (NSDictionary *)keyMapping {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keyMapping = @{@"a": @0x00,
                        @"s": @0x01,
                        @"d": @0x02,
                        @"f": @0x03,
                        @"h": @0x04,
                        @"g": @0x05,
                        @"z": @0x06,
                        @"x": @0x07,
                        @"c": @0x08,
                        @"v": @0x09,
                        @"b": @0x0B,
                        @"q": @0x0C,
                        @"w": @0x0D,
                        @"e": @0x0E,
                        @"r": @0x0F,
                        @"y": @0x10,
                        @"t": @0x11,
                        @"1": @0x12,
                        @"2": @0x13,
                        @"3": @0x14,
                        @"4": @0x15,
                        @"6": @0x16,
                        @"5": @0x17,
                        @"equal": @0x18,
                        @"9": @0x19,
                        @"7": @0x1A,
                        @"minus": @0x1B,
                        @"8": @0x1C,
                        @"0": @0x1D,
                        @"rightbracket": @0x1E,
                        @"o": @0x1F,
                        @"u": @0x20,
                        @"leftbracket": @0x21,
                        @"i": @0x22,
                        @"p": @0x23,
                        @"l": @0x25,
                        @"j": @0x26,
                        @"quote": @0x27,
                        @"k": @0x28,
                        @"semicolon": @0x29,
                        @"backslash": @0x2A,
                        @"comma": @0x2B,
                        @"slash": @0x2C,
                        @"n": @0x2D,
                        @"m": @0x2E,
                        @"period": @0x2F,
                        @"grave": @0x32,
                        @"keypaddecimal": @0x41,
                        @"keypadmultiply": @0x43,
                        @"keypadplus": @0x45,
                        @"keypadclear": @0x47,
                        @"keypaddivide": @0x4B,
                        @"keypadenter": @0x4C,
                        @"keypadminus": @0x4E,
                        @"keypadequals": @0x51,
                        @"keypad0": @0x52,
                        @"keypad1": @0x53,
                        @"keypad2": @0x54,
                        @"keypad3": @0x55,
                        @"keypad4": @0x56,
                        @"keypad5": @0x57,
                        @"keypad6": @0x58,
                        @"keypad7": @0x59,
                        @"keypad8": @0x5B,
                        @"keypad9": @0x5C,
                        @"return": @0x24,
                        @"tab": @0x30,
                        @"space": @0x31,
                        @"backspace": @0x33,
                        @"escape": @0x35,
//                        @"command": @0x37,
//                        @"shift": @0x38,
                        @"capslock": @0x39,
//                        @"option": @0x3a,
//                        @"control": @0x3b,
//                        @"rightshift": @0x3c,
//                        @"rightoption": @0x3d,
//                        @"rightcontrol": @0x3e,
//                        @"function": @0x3f,
                        @"volumeup": @0x48,
                        @"volumedown": @0x49,
                        @"mute": @0x4a,
                        @"f5": @0x60,
                        @"f6": @0x61,
                        @"f7": @0x62,
                        @"f3": @0x63,
                        @"f8": @0x64,
                        @"f9": @0x65,
                        @"f11": @0x67,
                        @"f10": @0x6d,
                        @"f12": @0x6f,
                        @"help": @0x72,
                        @"home": @0x73,
                        @"pageup": @0x74,
                        @"delete": @0x75,
                        @"f4": @0x76,
                        @"end": @0x77,
                        @"f2": @0x78,
                        @"pagedown": @0x79,
                        @"f1": @0x7a,
                        @"left": @0x7b,
                        @"right": @0x7c,
                        @"down": @0x7d,
                        @"up": @0x7e
                        };
    });
    return _keyMapping;
}

+ (NSDictionary *)revKeyMapping {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* keys = [[self keyMapping] keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
            return [n2 isGreaterThan:n1];
        }];
        NSArray* objs = [[[self keyMapping] allValues] sortedArrayUsingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
            return [n2 isGreaterThan:n1];
        }];

        _revKeyMapping = [NSDictionary dictionaryWithObjects:keys forKeys:objs];
    });
    return _revKeyMapping;
}

@end

#pragma mark - Hot Key Combo

@implementation ASHotKey

@synthesize target = _target;
@synthesize action = _action;
@synthesize object = _object;
@synthesize task = _task;
@synthesize combo = _combo;

- (void)setTask:(ASHotKeyTask)task {
    _task = [task copy];
}

- (void)setComboFromString:(NSString *)combo {
    NSArray* bits = [combo componentsSeparatedByString:@" "];
    NSMutableArray* keys = [NSMutableArray array];
    for (NSString* bit in bits) {
        ASKey* k = [ASKey fromNSString:bit];
        [keys addObject:k];
    }
    _combo = keys;
}

- (void)run:(NSEvent *)e {
    if (self.target && self.action &&
        [self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action
                          withObject:e
                          withObject:self.object];
#pragma clang diagnostic pop
    } else if (self.task) {
        self.task(e);
    }
}

- (NSString *)stringify {
    NSMutableArray* bits = [NSMutableArray array];
    for (ASKey* k in self.combo) {
        [bits addObject:[k stringify]];
    }
    return [bits componentsJoinedByString:@" "];
}

@end

#pragma mark - Hot Key Center

static ASHotKeyCenter* center = nil;

@implementation ASHotKeyCenter {
    NSMutableDictionary* _registeredHotKeys;
    NSMutableArray* _pressedKeys;
}

- (id)init {
    self = [super init];

    _registeredHotKeys = [NSMutableDictionary dictionary];
    _pressedKeys = [NSMutableArray array];

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent* e) {
        ASKey* key = [ASKey fromEvent:e];
//        NSLog(@"pressed: %@", [key stringify]);
        [_pressedKeys addObject:key];

        id next;
        NSDictionary* coll = _registeredHotKeys;
        for (ASKey* k in _pressedKeys) {
            next = coll[[k stringify]];
            if (next == nil) {
                [_pressedKeys removeAllObjects];
                return;
            }
            coll = next;
        }

        if ([next isMemberOfClass:[ASHotKey class]]) {
            [_pressedKeys removeAllObjects];
            [next run:e];
        }
    }];

    return self;
}

+ (ASHotKeyCenter *)sharedHotKeyCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [ASHotKeyCenter new];
    });
    return center;
}

- (BOOL)_registerHotKey:(ASHotKey *)hotKey {
    id next;
    NSMutableDictionary* coll = _registeredHotKeys;
    ASKey* k;
    NSString* key;

    for (int i = 0; i < hotKey.combo.count - 1; i++) {
        k = hotKey.combo[i];
        key = [k stringify];
        next = coll[key];

        if ([next isMemberOfClass:[ASHotKey class]]) {
            return NO;
        }

        if (next == nil) {
            next = [NSMutableDictionary dictionary];
            coll[key] = next;
        }

        coll = next;
    }

    k = hotKey.combo.lastObject;
    coll[[k stringify]] = hotKey;
    return YES;
}

- (BOOL)registerHotKey:(NSString *)combo
                target:(id)target
                action:(SEL)action
                object:(id)object {
    ASHotKey* hk = [ASHotKey new];
    [hk setComboFromString:combo];
    hk.target = target;
    hk.action = action;
    hk.object = object;

    return [self _registerHotKey:hk];
}

- (BOOL)registerHotKey:(NSString *)combo task:(ASHotKeyTask)task {
    ASHotKey* hk = [ASHotKey new];
    [hk setComboFromString:combo];
    hk.task = task;

    return [self _registerHotKey:hk];
}

- (NSDictionary *)registeredHotKeys {
    return _registeredHotKeys;
}

@end
