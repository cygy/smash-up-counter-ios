![Smash Up Counter - iOS companion application](Documentation/documentation-title.png?raw=true "Smash Up Counter - iOS companion application")

# Smash Up Counter

Companion application for playing the boardgame Smash Up.

## Disclaimer

This source code is for **purposal only** and it is intended to be distributed on the AppStore. It is just a demonstration to how to use the *SpriteKit* and *RxSwift* frameworks and the *Coordinator* and *Delegate* patterns.

All the names, images could be copyrighted by the owner of Smash Up.

## Requirements

- Xcode 11.3
- Swift 5

## Installation

`carthage update`

## What is Smash Up?

> *Smash Up, designed by Paul Peterson, is the all-new Shufflebuilding game from Alderac Entertainment Group.  In Smash Up players take two factions, such as pirates, ninja, robots, zombies, and more, and combine their decks into a force to be reckoned with!*
>
> source: https://smashup.fandom.com/wiki/SmashUp_Wiki

In this famous boardgame, up to four players attack bases to gain points. The first player reaching 15 points is the winner. Each player has two factions, i.e. vampires, spies, pocket monsters, sharks, tornados... A faction is composed of a set of 20 cards. The players attack the bases with itws own cards.

## The application

This application is a companion for the games, it helps the players to distribute randomly the factions and to track the scores during the game.
- Add up to four players
- Choose the add-ons and/or the factions
- The factions are randomly distributed to players
- See the points for all the game along!

For **iOS** only. Only optimized for the iPad devices for now.

<video width="320" height="240" controls>
  <source src="Documentation/documentation_video.mp4" type="video/mp4">
</video>

## Screens

![Screen flow](Documentation/documentation-smashup-counter-screens.png?raw=true "Smash Up Counter Screen flow")

The screen flow is pretty straightforward:
1. the home screen is displayed at the application launch while the initial data is loading.
2. the next screen is the players screen, the players must be added here.
3. the third screen is the add-ons/factions screen. The factions can be selected or unselected to be included or not to the factions to distribute to the players.
4. the following screen reveals the factions distributed randomly to the players.
5. then the game screen is displayed. Here the scores of the players can be incemented or decremented.
6. the final screen is the end game screen. The winner is designated. A new game can be launched.

## Architecture

![Diagram](Documentation/documentation-diagram.png?raw=true "Smash Up Counter Diagram")

This simple application is structured around two **singletons**: the `ApplicationState` and the `ApplicationCoordinator` objects.

The `ApplicationState` singleton owns the entire state of the application. The other objects must refer to it to know the state of the application. The **RxSwift** framework is used here to allow the other objects to subscribe to the properties of the `ApplicationState` singleton and to receive the updates.

The `ApplicationCoordinator` singleton uses the **coordinator pattern** to manage and to display the different scenes on the screen. It observes the updates of `ApplicationState` singleton's state property, and updates the scenes accordingly.
It is the only object allowed to update the state of the application.

The `SceneController` objects manage and update the scenes currently displayed on the screen. These controllers could be considered as coordinators but because they manage a scene they are considered as controllers like the `UIViewController` classes from the **UIKit** framework.
These controllers forward the actions from the scenes (the UI) to the `ApplicationCoordinator` singleton thanks to the **delegate pattern**.

### Links

- More about **SpriteKit**: https://developer.apple.com/spritekit/
- More about **RxSwift**: https://github.com/ReactiveX/RxSwift
- More about the **coordinator pattern**: https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
- More about the **singleton pattern**: https://en.wikipedia.org/wiki/Singleton_pattern

## The model

The model of the application is composed by simple structs and objects.

### State

The *State* represents the current state of the application. Each value of this enum has a corresponding scene, screen.

### Player

A *Player* is represented by its name, its amount of points and a list of *Factions*.

### Add-On

An *AddOn* is represented by its identifier, its name, its image, its factions and if it selected or not.

### Faction

A *Faction* is represented by its identifier, its name, its image and if it selected or not.

## Application state

The `ApplicationState` singleton contains the state of the entire application, it represents the single source of truth. Any object can subscribe to its property to be up-to-dated and to respond accordingly. Its property must be updated via the corresponding methods.

## Scenes

A `Scene` object is a dumb object: it only does and displays things that its `SceneController` object tells it. A scene doesn't know anything about the application, it only manages its SKNodes. A scene object forwards the actions that it receives by the user to its delegate.

## Scene controllers

A `SceneController` object is the link between the `ApplicationState` singleton and the `Scene` object that it manages. The controller gives its scene the data that it needs. A controller observes the application state to update accordingly its scene. A controller is the delegate of its scene in order to apply the actions passed by the user.

## Application Coordinator

The `ApplicationCoordinator` singleton manages the different scene controllers, it observes the application state and displays accordingly the right scene controller. The application coordinator is the delegate of each sceen controller and updates the application state consequently.
