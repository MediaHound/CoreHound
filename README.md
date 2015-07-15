
# CoreHound: Getting Started

## What is CoreHound?
CoreHound is the iOS SDK for accessing The Entertainment Graph through MediaHound's API. Search for media content across movies, books, games, TV, and more. Discover relationships across media via traits and contributors. CoreHound is a fast and easy SDK that lets you enhance your iOS apps with access to an entire world of entertainment content. 

## Install CoreHound

To get started with CoreHound, install it with [CocoaPods](http://cocoapods.org). Add the following line to your **Podfile**:

```
pod 'CoreHound', :git => "https://github.com/MediaHound/CoreHound.git"
```

Run `pod install`, and you can now use CoreHound by importing it:

```objc
#import <CoreHound/MHApi.h>
```

### Example Project

If you want to explore the example project, SearchLite, just run:

```
pod try CoreHound
```

The SearchLite project demonstrates many features like Application OAuth, Search, Images, and Contributor relationships.

## The world of media content
The Entertainment Graph contains many types of objects — movies, books, people, traits, etc.

The Entertainment Graph contains a series of objects representing media content, users, collections, etc and the connections between those objects. These objects and connections form a graph of media content. Social interactions live on top of that content graph. 

Every object in The Entertainment Graph is uniquely identified by an identifier—- its `mhid`. For example, the movie *Saving Private Ryan* has an `mhid` of *mhmovt8xqWDBFoCiL92HnfA4uYDV8HzPaig8ucgxJEsP*.

Every object in The Entertainment Graph has a type—- Movie, Book, Contributor, etc. There is a well defined type hierarchy, so you can easily work with objects of varying types. 

![](https://github.com/MediaHound/CoreHound/blob/doc-updates/Images/mh-object-types.png)

*Saving Private Ryan* is an `MHMovie`, and *Catch 22* is an `MHBook`. Both `MHMovie` and `MHBook` inherit from `MHMedia`. This lets us work with entertainment across different content types easily. We can view the content as an `MHMedia`. When we need to specifically work with books, we can treat them as an `MHBook`.

All objects in The Entertainment Graph inherit from the `MHObject` class. This class provides the base functionality that all graph objects conform to. All objects have metadata represented as an `MHMetadata`:

Property | Description
-------- | -------------
mhid | The globally unique identifier of the object
name | A user-displayable name of the object
objectDescription | A user-displayable description of the object
createdDate | When the object was created in the graph

Some content types have more metadata properties. For example all `MHMedia` objects have an `MHMediaMetadata` which extends `MHMetadata` adding a `releaseDate` property.

Most `MHObjects` also have a primary image. The primary image is the main visual representation for the object. An `MHImage` provides image metadata including URLs to the image at varying resolutions.

`MHObjects` have relations to other `MHObjects`. For example, given an `MHMovie`, we can query for the people who have contributed to the movie (actors, director, composer, etc) like this:

```objc
[movie fetchContributors]; 
```

This gives you an array of `MHContributors` who are related to that movie.

The Entertainment Graph is highly connected. Here is a small example of the types of connections between content:

![](https://github.com/MediaHound/CoreHound/blob/doc-updates/Images/mh-graph-example.png)

## CoreHound is highly **asynchronous**
Almost all interaction you have with the CoreHound SDK is through asynchronous APIs. CoreHound uses *promises* as its asynchronous pattern. As a simple example, to find the release date of *The Usual Suspects*, you would write:

```objc
NSString* theUsualSuspectsMhid = @"mhmovI8Y9tWpUFibqYGZYddt1I5q3znlRAuSQ2a6N437";
[MHObject fetchByMhid:theUsualSuspectsMhid].then(^(MHObject* result) {
    NSDate* releaseDate = result.metadata.releaseDate;
    NSLog(@"The Usual Suspects (%@)", releaseDate);
});
```

The [PromiseKit docs](http://promisekit.org) are a great way to learn more about how to interact with promises.

## Objects are progressively loaded
Since The Entertainment Graph contains so much information about each object and all of its relationships, you must always explicitly fetch the data you want. 

If you want to load the primary image for a movie, you must do this:

```objc
[movie fetchPrimaryImage].then(^(MHImage* primaryImage) {
    NSString* url = primaryImage.large.url;
    // Download image at `url`.
});
```

CoreHound does its best to ensure these fetches are fast. Typically all the data will be cached, so these requests will be (almost) instantaneous. Only if absolutely required will CoreHound make a network request to get the data.

Sometimes we want to be notified anytime an `MHObject`'s properties change. All `MHObject` properties are KVO-compliant:

**NOTE:** CoreHound has no thread affinity for KVO notifications. This means that all KVO notifications will be posted from background threads. If you need to tie KVO notifications to UI updates, make sure to dispatch to the main thread when the change notifications occur. 

## CoreHound is built for large datasets
Since there are lots of connections between objects in The Entertainment Graph, all methods that return other `MHObjects` take advantage of paging. That means you will only get a subset of results. If you need more, you can fetch more, one page at a time.

The `MHPagedResponse` class encapsulates a page of results. You can use the `content` property to access the results of that page:

```objc
[movie fetchContributors].then(^(MHPagedResponse* response) {
    NSArray* firstPageResults = response.content;
});
```

If you need to access the next page just call `-fetchNext` on the paged response:

```objc
[movie fetchContributors].then(^(MHPagedResponse* firstPage) {
    // Access firstPage.content
    return [response fetchNext];
}).then(^(MHPagedResponse* secondPage) {
     // Access secondPage.content
});
```

## Searching The Entertainment Graph
To perform searches against The Entertainment Graph, use the `MHSearch` class:

```objc
[MHSearch fetchResultsForSearchTerm:@"The Usual Suspects"
scope:MHSearchScopeMovie].then(^(MHPagedResponse* response) {
    MHObject* firstResult = response.content.firstObject;
    NSLog(@"Found %@", firstResult.metadata.name);
});
```

Search results are just standard `MHObjects`, so you can interact with them like you would an MHObject you got back from `fetchContributors`.

## Exploring relations between content
When exploring connections between content, just getting back `MHObjects` would be limiting. We need to know  information about the relationship between the two `MHObjects`. Consider fetching the contributors for a movie. If all we got back was the `MHContributors`, we wouldn't know how that person contributed to the movie. Were they the director, an actor, or produced the movie? 

To capture this additional information, we use an `MHContext` object. Each entry in an `MHPagedResponse` is an `MHRelationalPair`, which combines both an `MHObject` and an `MHContext`.

```objc
[movie fetchContributors].then(^(MHPagedResponse* response) {
    NSArray* firstPageResults = response.content;
    for (MHRelationalPair* pair in firstPageResults) {
       MHObject* obj = pair.object;
       MHContext* ctxt = pair.context;
    }
});
```

## Acting on Behalf of a User
Entertainment is only part of The Entertainment Graph. Users bring social interaction and knowledge to the graph. CoreHound lets you authenticate on behalf of the user and take social actions on media, create collections, or interact with other users.

### Logging in a user

CoreHound offers two ways to log in a user: User OAuth and Enterprise Auth. Most applications will use User OAuth. Enteprise partners can opt-in to an Enterprise Auth flow.

### Logging in using User OAuth

*Coming soon...*

### Logging in using Enterprise Auth

Enterprise Auth allows you to directly log a user in using their username and password. You should prompt the user for their username and password and then call the `-loginWithUsername:password` method on `MHLoginSession`:

```objc
[MHLoginSession loginWithUsername:usernameField.text
                         password:passwordField.text].then(^{
    // User sucesffuly logged in
}).catch(^(NSError* error) {
    // Show the user an error
});
```

After a succesful login, CoreHound will securely store the user's credentials to the Keychain. Because of this, you no longer need to store the user's credentials. **You should not store the user's credentials anywhere!**

Once a user has succesfully logged in once, on their next visit to your app, you should try to automatically log in for them.

```objc
[MHLoginSession loginUsingSavedCredentials].then(^{
    // User sucesffuly logged in
}).catch(^(NSError* error) {
    if ([error.domain isEqualToString:MHErrorDomain]) {
        if (error.code == MHLoginSessionNoSavedCredentialsError) {
            // User has no saved credentials
            // in the keychain.
        }
        else if (error.code == MHLoginSessionInvalidCredentialsError) {
            // The stored credentials are no longer valid.
            // The user may have changed them elsewhere.
        }
    } 
});
```

Once a user is logged in, you can access the currently logged in user via the `MHLoginSession`:

```objc
MHUser* currentUser = [MHLoginSession currentSession].user;
```

### Creating users in Enterprise Auth

To create a new user, you call the `MHUser` create method. After the creation promise resolves, you can log the user in using `MHLoginSession`.

```objc
[MHUser createWithUsername:usernameField.text
                  password:passwordField.text
                     email:emailField.text
                 firstName:firstNameField.text
                  lastName:lastnameField.text].then(^{
    return [MHLoginSession loginWithUsername:usernameField.text
                                          password:passwordField.text];
    // At this point, you no longer need to store the
    // username or password. You should actively stop
    // storing them, to ensure the user's security.
}).then(^(MHLoginSession* session) {
    // At this point the user is now logged in.
    // You can upload a profile image if you'd like
    return [session.user setProfileImage:userImage];
});
```

### Login/Logout Notifications

CoreHound emits login and logout notifications if you want to listen for these events in a decoupled manner:

```objc
// Set up notification observer for login
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(userDidLogin:)
                                             name:MHLoginSessionUserDidLoginNotification
                                           object:nil];

// Set up notification observer for logout
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(userDidLogout:)
                                             name:MHLoginSessionUserDidLogoutNotification
                                           object:nil];
```

## Application OAuth

If your application does not require a logged-in user, then you do not need to perform User OAuth or Enterprise Auth. Instead, you need to perform Application OAuth to access the MediaHound API. You must first have your Client ID and Client Secret, which you can get from the MediaHound Developer Portal.

```objc
[[MHSDK sharedSDK] configureWithClientId:@"YOUR CLIENT ID"
                            clientSecret:@"YOUR CLIENT SECRET"];
```

This method returns a promise, which resolves when the SDK has been succesfully configured. You must not call into CoreHound, until this promise has resolved.

## CoreHound provides meaningful suggestions

From any media content, you can find other related media content. Given an `MHMedia`, simply call `fetchRelated`:

```objc
[movie fetchRelated].then(^(MHPagedResponse* response) {
    MHMedia* firstRelated = response.content.firstObject;
});
```

If you want to find related content to multiple `MHMedia`, then you can use:

```objc
MHMovie* savingPrivateRyan = /* */;
MHMovie* theUsualSuspects = /* */;
[MHMedia fetchRelatedTo:@[savingPrivateRyan, theUsualSuspects]];
```

## CoreHound uses **flexible networking**
CoreHound uses the network extensively to asynchronously provide data and results as you request it. For advanced use cases, though, you need fine-grain control over how CoreHound requests are scheduled compared to your own networking requests. CoreHound exposes a clear API for controlling caching, priority, cancelation, and reprioritization. This networking infrastructure is provided by [Avenue](https://github.com/MediaHound/Avenue), a general networking library (built upon [AFNetworking](https://github.com/AFNetworking/AFNetworking)) that you can use for all network requests in your app.

All CoreHound **fetch** APIs have a version that takes 3 parameters:

- Forced: whether to use a cached version if available
- Priority: how to schedule this request compared to other concurrent network requests
- Network Token: a token which allows cancelation and priority changes

In the following example, we fetch a movie's contributors, explicitly ignoring the cache. We also prioritize this request as `Low`, meaning it will only execute after all `High` priority requests finish.

```objc
[movie fetchContributorsForced:YES
                      priority:[AVENetworkPriority
        priorityWithLevel:AVENetworkPriorityLevelLow
                  networkToken:nil].then(^(MHPagedResponse* response) {
    // use the results
}];
```

And in the following example, we've created a `AVENetworkToken` and passed it into the `-fetchContributorsForced:priority:networkToken` method. Afterwards, we call `-cancel` on the token, and the network request will be cancelled (if it has not already completed).

```objc
AVENetworkToken* token = [[AVENetworkToken alloc] init];
[movie fetchContributorsForced:YES
                      priority:[AVENetworkPriority
        priorityWithLevel:AVENetworkPriorityLevelLow
                  networkToken:token].then(^(MHPagedResponse* response) {
    // use the results
}];
[token cancel];
```

## Media

Here is a list of all media types in The Entertainment Graph. 

#### Video

Media          | Description
-------------- | -----------
MHMovie        | A feature-length motion picture
MHShowEpisode  | A single installment of video content within a sequence of serialized content
MHShowSeason   | An ordered list of MHShowEpisode objects
MHShowSeries   | An ordered list of MHShowSeason objects
MHMusicVideo   | A video recording accompanying a song or of song performance
MHSpecial      | A single installment of unserialized video content
MHTrailer      | A short promotional video intended to preview the content

#### Audio

Media          | Description
-------------- | -----------
MHTrack        | An individual piece of music or audio content 
MHAlbum        | An ordered list of MHTracks

#### Literature

Media          | Description
-------------- | -----------
MHBook         | A novel or nonfiction literary work
MHComicBook    | A short, serialized work presented in comic-strip format
MHGraphicNovel | A novel presented in comic-strip format
MHNovella      | A work of fiction shorter than a novel but longer than a short story
MHPeriodical   | A collection of news, information, and features published at regular intervals 

#### Gaming

Media          | Description
-------------- | -----------
MHGame         | A piece of interactive content that provides structured playing

#### Mixed

Media          | Description
-------------- | -----------
MHMediaGroup   | An unordered list of MHMediaObjects
MHMediaSeries  | An ordered list of MHMedia Objects
MHUniverse     | A special unordered list of MHMediaObjects

## Traits

Here is a list of all trait types in The Entertainment Graph. 

Trait            | Description | Examples
---------------- | ----------- | --------
MHGenre          | A category of content based on stylistic criteria | `Drama`, `Comedy`
MHSubgenre       | A more specific category of content within a less specific Genre | `Romantic Comedy`, `Political Thriller`
MHMood           | The tone or attitude of the content; or how the content is perceived by the audience/ makes it feel | `Absurd`, `Goofy`, `Campy`
MHQuality        | An abstract or subjective attribute of the content | `Cult`, `Indie`, `Visually Striking`, `Epic Scope`, `Moving`, `Time-Sensitive Viewing`, `Avant Garde`
MHStyleElement   | A specific attribute pertaining to how the content is composed | `Animated`, `Live Action`, `Hand Drawn`, `Narration`, `Segments`, `Episodic`, `Anime`, `Manga`
MHStoryElement   | A key plot point, specific setting, item, or event that appears or happens within the content | `Current Events`, `War`, `Cops`
MHMaterialSource | The source material for the content, or where the content's story originated | `Book`, `Graphic Novel`, `True Story`
MHTheme          | The unifying subject or idea of the type of visual work | `Overcoming the Odds`, `Man Vs Nature`
MHAchievement    | A notable accomplishment or award for the content | `Academy Awards`, `Tony`, `Emmy`, `Rolling Stone Top 100 Albums`
MHEra            | The time period in which the content was released or set | `Post-War`
MHAudience       | The consumer group for which the content is intended | `Kids`
MHFlag           | An appropriateness warning for the content | `Nudity`, `Explicit`, `R Rated`
MHGraphGenre     | A category of content made up of two or more different MHTraits | *WIP*


## License

CoreHound is available under the Apache License 2.0. See the LICENSE file for more info.
