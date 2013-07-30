//
//  ASHotKeyCenter.h
//  shorrt
//
//  Created by Alexander Solovyov on 30/7/13.
//  Copyright (c) 2013 Alexander Solovyov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ASHotKeyTask)(NSEvent*);


@interface ASKey : NSObject

@property (nonatomic) unsigned short code;
@property (nonatomic) NSUInteger flags;

+ (NSDictionary*)modifiers;
+ (NSDictionary*)keyMapping;
+ (NSDictionary*)revKeyMapping;

+ (ASKey *)fromNSString:(NSString *)key;
+ (ASKey *)fromEvent:(NSEvent *)e;

+ (NSUInteger)modifierByName:(NSString *)name;
+ (unsigned short)codeByKey:(NSString *)key;
+ (NSString *)keyByCode:(unsigned short)code;

- (NSString *)stringify;

@end


@interface ASHotKey : NSObject

@property (nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic) id object;
@property (nonatomic, readonly) ASHotKeyTask task;

@property (nonatomic) NSArray* combo;

- (void)run:(NSEvent *)e;
- (NSString *)stringify;

@end


@interface ASHotKeyCenter : NSObject

+ (id)sharedHotKeyCenter;

- (BOOL)registerHotKey:(NSString*)combo target:(id)target action:(SEL)action object:(id)object;

- (BOOL)registerHotKey:(NSString*)combo task:(ASHotKeyTask)task;

- (NSDictionary *)registeredHotKeys;

@end
