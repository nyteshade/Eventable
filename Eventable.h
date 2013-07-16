//
// Eventable.h
// Copyright (c) 2013 Gabriel Harrison
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

#import <Foundation/Foundation.h>

@class NEEventInfo;
@class NEEventListener;

typedef void (^NEEventAction)(NEEventInfo *);

@interface NEEventInfo : NSObject
@property NSDictionary *eventData;
@property NSMutableDictionary *dataset;
@property NSString *eventName;
@property id context;

- (id) initWithListener:(NEEventListener *)listener;
- (id) initWithListener:(NEEventListener *)listener andData:(NSMutableDictionary *)data;
- (id) initWithListener:(NEEventListener *)listener andContext:(id)eventContext;
- (id) initWithListener:(NEEventListener *)listener andContext:(id)eventContext andData:(NSMutableDictionary *)data;
@end

@interface NEEventListener : NSObject
@property NSString *eventName;
@property NSDictionary *eventData;
@property (atomic,strong) NEEventAction action;

- (id) init:(NSString *)name withAction:(NEEventAction) eventAction;
- (id) init:(NSString *)name withAction:(NEEventAction) eventAction andData:(NSDictionary *)data;
@end

@interface NEEventable : NSObject {
  // The format for listeners is to use the eventName as a key. If the
  // event name doesn't yet exist, an array is assigned to the name. The
  // array contains instances of EventListener. These are used whenever
  // an event is fired to generate the EventInfo.
  NSMutableDictionary *listeners;
}

- (void) addEvent:(NSString *)eventName;

- (void) addListener:(NEEventListener *)listener;
- (void) addListener:(NSString *)eventName withAction:(NEEventAction)action;
- (void) addListener:(NSString *)eventName withEventData:(NSDictionary *)eventData withAction:(NEEventAction)action;

- (NSSet *) eventNames;

- (void) fireEvent:(NSString *)eventName;
- (void) fireEvent:(NSString *)eventName withContext:(id)context;
- (void) fireEvent:(NSString *)eventName withData:(NSMutableDictionary *)data;
- (void) fireEvent:(NSString *)eventName withContext:(id)context withData:(NSMutableDictionary *)data;

- (void) removeListeners;
- (void) removeListeners:(NSString *)eventName;
- (void) removeListener:(NSString *)eventName withAction:(NEEventAction)action;

@end
