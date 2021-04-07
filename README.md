# WiseEmotions

## Task

Develop one app showing a list of Pokémon with name and pictures.
When user selects a Pokémon from the list, app must show details of the Pokémon such as name, picture(s), stats and type (fire, poison, etc.)

- [x] Use Swift 5.3 
- [x] Set target to SDK iOS 11 
- [x] The UI must be created without the use of Xib or Storyboard, it must be dynamic and it must support both iPhone and iPad 
- [x] Use no more than 2 (two) external libraries, and motivate their use 
- [x] You can use CocoaPods, Carthage or SwiftPM; provide motivation for your choice (SwiftPM used)
- [x] Use MVVM pattern
- [x] Verify build completes successfully before considering the project complete!
- [x] Publish code on a github public repository, or in a zip archive
- [x] Create a README.md file collecting your implementation choices motivations

## Task
- [ ] Use at most 1 (one) external library (and motivate its use)
- [x] Make the app work offline too 
- [ ] Write Unit Tests 
- [x] Customize project with something you believe can be useful for this app 


# Libraries:

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
