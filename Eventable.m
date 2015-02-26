//
// Eventable.m
// Copyright (c) 2013 Brielle Harrison
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Eventable.h"

@implementation NEEventInfo
@synthesize eventName, eventData, dataset, context;

- (id) initWithListener:(NEEventListener *)listener {
  self = [super init];
  if (self) {
    self.eventName = [listener.eventName copy];
    self.eventData = [listener.eventData copy];
    self.dataset = nil;
    self.context = nil;
  }
  return self;
}

- (id) initWithListener:(NEEventListener *)listener andData:(NSMutableDictionary *)data {
  self = [super init];
  if (self) {
    self.eventName = [listener.eventName copy];
    self.eventData = [listener.eventData copy];
    self.dataset = data;
    self.context = nil;
  }
  return self;
}

- (id) initWithListener:(NEEventListener *)listener andContext:(id)eventContext {
  self = [super init];
  if (self) {
    self.eventName = [listener.eventName copy];
    self.eventData = [listener.eventData copy];
    self.dataset = nil;
    self.context = context;
  }
  return self;
}

- (id) initWithListener:(NEEventListener *)listener andContext:(id)eventContext andData:(NSMutableDictionary *)data {
  self = [super init];
  if (self) {
    self.eventName = [listener.eventName copy];
    self.eventData = [listener.eventData copy];
    self.dataset = data;
    self.context = eventContext;
  }
  return self;
}
@end

@implementation NEEventListener
@synthesize eventName, eventData, action;

- (id) init:(NSString *)name withAction:(NEEventAction) eventAction {
  self = [super init];
  if (self) {
    eventName = name;
    eventData = nil;
    action = eventAction;
  }
  return self;
}

- (id) init:(NSString *)name withAction:(NEEventAction) eventAction andData:(NSDictionary *)data {
  self = [super init];
  if (self) {
    eventName = name;
    eventData = data;
    action = eventAction;
  }
  return self;
}
@end

@implementation NEEventable

- (id)init {
  self = [super init];
  if (self) {
    listeners = [@{} mutableCopy];
  }
  return self;
}

- (void) addEvent:(NSString *)eventName {
  if ([listeners objectForKey:eventName] == nil) {
    [listeners setObject:[@[] mutableCopy] forKey:eventName];
  }
}

- (void) addListener:(NEEventListener *)listener {
  [self addEvent:listener.eventName];
  
  NSMutableArray *list = [listeners objectForKey:listener.eventName];
  [list addObject:listener];
}

- (void) addListener:(NSString *)eventName withAction:(NEEventAction)action {
  NEEventListener *listener = [[NEEventListener alloc] init:eventName withAction:action];
  [self addListener:listener];
}

- (void) addListener:(NSString *)eventName withEventData:(NSDictionary *)eventData withAction:(NEEventAction)action {
  NEEventListener *listener = [[NEEventListener alloc] init:eventName withAction:action andData:eventData];
  [self addListener:listener];
};

- (NSSet*) eventNames {
  return [listeners keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
    return YES;
  }];
};

- (void) fireEvent:(NSString *)eventName {
  NSMutableArray *list = [listeners objectForKey:eventName];
  for (NEEventListener *listener in list) {
    @try {
      NEEventInfo *info = [[NEEventInfo alloc] initWithListener:listener];
      listener.action(info);
    }
    @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
    }
  }
}

- (void) fireEvent:(NSString *)eventName withContext:(id)context {
  NSMutableArray *list = [listeners objectForKey:eventName];
  for (NEEventListener *listener in list) {
    @try {
      NEEventInfo *info = [[NEEventInfo alloc] initWithListener:listener];
      info.context = context;
      listener.action(info);
    }
    @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
    }
  }
}

- (void) fireEvent:(NSString *)eventName withData:(NSMutableDictionary *)data {
  NSMutableArray *list = [listeners objectForKey:eventName];
  for (NEEventListener *listener in list) {
    @try {
      NEEventInfo *info = [[NEEventInfo alloc] initWithListener:listener];
      info.dataset = data;
      listener.action(info);
    }
    @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
    }
  }
}

- (void) fireEvent:(NSString *)eventName withContext:(id)context withData:(NSMutableDictionary *)data {
  NSMutableArray *list = [listeners objectForKey:eventName];
  for (NEEventListener *listener in list) {
    @try {
      NEEventInfo *info = [[NEEventInfo alloc] initWithListener:listener];
      info.context = context;
      info.dataset = data;
      listener.action(info);
    }
    @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
    }
  }
}

- (void) removeListeners {
  [listeners removeAllObjects];
}

- (void) removeListeners:(NSString *)eventName {
  [listeners removeObjectForKey:eventName];
}

- (void) removeListener:(NSString *)eventName withAction:(NEEventAction)action {
  NSMutableArray *list = [listeners objectForKey:eventName];
  [list removeObject:action];
}

@end
