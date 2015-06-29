
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

## The world of media content
The Entertainment Graph contains many types of objects — movies, books, people, traits, etc.

The Entertainment Graph contains a series of objects representing media content, users, collections, etc and the connections between those objects. These objects and connections form a graph of media content. Social interactions live on top of that content graph. 

Every object in The Entertainment Graph is uniquely identified by an identifier—- its `mhid`. For example, the movie *Saving Private Ryan* has an `mhid` of *mhmovt8xqWDBFoCiL92HnfA4uYDV8HzPaig8ucgxJEsP*.

Every object in The Entertainment Graph has a type—- Movie, Book, Contributor, etc. There is a well defined type hierarchy, so you can easily work with objects of varying types. 

![](https://github.com/MediaHound/CoreHound/blob/doc-updates/images/mh-object-types.png)

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

![](https://github.com/MediaHound/CoreHound/blob/doc-updates/images/mh-graph-example.png)

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

CoreHound offers two ways to log in a user: User OAuth and Enterprise xAuth. Most applications will use User OAuth. Enteprise partners can opt-in to an xAuth flow.

### Logging in using User OAuth

**TODO**

### Logging in using Enterprise xAuth

**TODO**

### Creating users in Enterprise xAuth

**TODO**

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

## License

CoreHound is available under the Apache License 2.0. See the LICENSE file for more info.
