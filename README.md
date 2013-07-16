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

Listeners can also be added with baseline event data. This data will be present in the NEEventInfo instance regardless of whether or not the event was fired with additional parameters or data. Adding an event listener this way can be done like this

```objc
  NEEventable *eventable = NEEventable.new;
  [eventable addListener:@"eventA" withEventData:@{@"time":@"night", @"staff": @8} withAction:^(NEEventInfo *info) {
    NSLog(@"There are %ld staff members and this event takes place at %@", [info.eventData objectForKey:@"staff"],
        [info.eventData objectForKey:@"time"]);
  }];
  
  // Somewhere else in the code
  [eventable fireEvent:@"eventA"];
```

This would print the output "There are 8 staff members and this event takes place at night". This would happen every time the fireEvent is called for that event type. If there are any additional listeners for that event, their code would also fire. They can choose to use or not use the data in info.eventData. 
