# WishApp

![icon](https://github.com/sharedRoutine/WishApp/blob/master/WishApp/Assets.xcassets/AppIcon.appiconset/AppIcon60x60%403x.png)

(icon by [Aviorrok](https://twitter.com/AVIROK1))

Apple has removed its Wishlist feature in iOS 11 and while users have come up with different ways such as [this](https://www.reddit.com/r/iphone/comments/8l8mkm/since_apple_removed_the_wishlist_in_ios_11_this/) I wanted to create a simple app that helps them keep track of apps they want etc.
So I started this project and wanted to put it out for free with the ability to donate to me and the Designer to show appreciation.

I wanted to keep the app simple yet it allows you to do the core things when it comes to a wish list.

## Features

- Importing from the AppStore
- Searching Apps via the App
- Marking Wishes as completed
- Refreshing App Information
- Sorting Wishes

## Here is how the app looks like

<div style="text-center">
<img src="https://i.imgur.com/hkSgBYw.png" alt="alt text" width="main view" height="500px">
<img src="https://i.imgur.com/IAZQJfh.png" alt="alt text" width="main view" height="500px">
</div>

## Why I decided to open source it / (Todo)

The app itself is complete, yet one could add more things like changing from dark to light mode or some other features.
This app however was not accepted in the AppStore and I would have to add more unique features - even though I see it as a simple app that does just that.
I at first wanted to postpone the app development until I had an idea on how I can make add more features to it. But then I decided to share this app as part of my open source projects as it is almost completely done (besides possible extra features).

This brings me to a possible to-do:

- Dark Mode Switch
- More Features

## How this app works

- It uses [Realm.io](https://realm.io/docs/swift/latest) as a backend database and has a single Model [WishListItem.swift](https://github.com/sharedRoutine/WishApp/blob/master/WishApp/Objects/WishListItem.swift)
- It uses the [iTunes Search API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/) to search for apps within the app
- It implements basic in app purchasing for the donations
- Adds a share extension to import from the AppStore

## Copyright / License

- [WishApp's LICENSE](https://github.com/sharedRoutine/WishApp/blob/master/LICENSE) applies
- You may not use the icons of this app in any way. [Icons made by Aviorrok for WishApp](https://twitter.com/AVIROK1)
- All licenses of third party libraries used in this app apply. (See [Acknowledgements.plist](https://github.com/sharedRoutine/WishApp/blob/master/WishApp/Acknowledgements.plist) and [Realm.plist](https://github.com/sharedRoutine/WishApp/blob/master/WishApp/Realm.plist))

Otherwise enjoy reading the source code and if you have any questions, let me know!
