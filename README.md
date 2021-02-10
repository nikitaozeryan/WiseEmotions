# WiseEmotions

# Libraries:

## Alamofire

Used to connect with API

## ReactiveSwift, ReactiveCocoa

ReactiveSwift offers composable, declarative, and flexible primitives that are built around the grand concept of streams of values over time.

These primitives can be used to uniformly represent common Cocoa and generic programming patterns that are fundamentally an act of observation, e.g. delegate pattern, callback closures, notifications, control actions, responder chain events, futures/promises, and key-value observing (KVO).

# Dependency manager

## Swift Package Manager

1) It’s the new standard build by Apple to create Swift apps.

2) Automatically manage a dependency’s dependencies. If a dependency relies on another dependency, Swift Package Manager will handle it for you.

3) Anyone inside the project will easily know what dependencies your app is using.

# Implementation choices motivations

## CoreData

1) Native Apple database

2) Optimizing Core Data Performance using NSFetchedResultsController

2) Much better memory management. With a plist you must load the entire thing into memory; with Core Data only the objects you're currently using need to be loaded. Also, once objects are loaded, they're normally placeholder "fault" objects whose property data doesn't load until you need it.

3) Related to the above, when you have changed, you can save only the changed objects, not the entire data set.

4) You can read/write your model objects directly instead of converting them to/from something like an NSDictionary.

5) Built-in sorting of objects when you fetch them from the data store.

6) Rich system of predicates for searching your data set for objects of interest.

7) Relationships between entities are handled directly, as properties on the related objects. With a plist you would need to do something like store an object ID for a relationship, and then look up the related object.

8) Optional automatic validation of property values.

## NSCache to saving images

1) It's easy to use

2) Memory allocation
