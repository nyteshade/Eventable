Eventable
=========

Eventables are small pub/sub objects that can be reused. The can listen for any number of custom events and take blocks of code to act upon. Their usage is very simple and hopefully straight forward. I've also tried to provide the ability to pass as much data as necessary for each event action. This code is written to be used with ARC.

Example of code usage. 

```objc
  NEEventable *eventable = [[NEEventable alloc] init];
  [eventable addListener:@"custom-event" withAction:^(NEEventInfo *event) {
    NSLog(@"Custom event listener 1");
  }];
  [eventable addListener:@"custom-event" withAction:^(NEEventInfo *event) {
    NSLog(@"Custom event listener 2");
  }];

  // ... someplace else in the code with access to the eventable object
  [eventable fireEvent:@"custom-event"];

```

This example logs two messages, one after the other, in the order they were added to the eventable. There is no easy way to modify this order other than to remove and add to the end of the list with the current gist.
