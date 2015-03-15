Use this page to document feature requests for the [Plazes API](http://plazes.com/api/docs).  Try to be as descriptive as possible with your feature request, and include a use case if possible.

Please note that, in general, the new Plazes API is considerably more 'atomic' than the old one -- for example, some methods will return you a reference to a Plazes users' ID which you then have to use to make a second API call to get their user details. This 'atomicity' was a deliberate design decision, and while it pushes some of the application logic out into your own application, it also makes the API much simpler and more general-purpose.

## Latitude/Longitude Parameter for GET /plazes.xml ##

### Requested By ###

[Peter Rukavina](http://ruk.ca/)

### Feature Description ###

Currently the **GET /plazes.xml** method supports only the **q** parameter (which does a keyword search of name, address, zip\_code, city, state (and full state name), country\_code (and country names) category and tags fields) and the **mac\_address** parameter.

There is, however, no way to pass a geographic point (latitude/longitude) as a parameter, allowing one to say, in effect, "here is where I am, show me all the nearby Plazes."

### Why this would be useful ###

Having such a parameter would allow for experiments with mobile device/GPS integration -- for example, creating an applocation for a GPS-enabled mobile device that could provide a location-aware list of nearby plazes, perhaps filtered by category.

It would also allow for web-based mapping mash-ups that pass the centre point of the map, get back a collection of Plazes, and map them.

## Oauth authorization ##

### Requested By ###
[Till Klampaeckel](http://till.klampaeckel.de)

### Feature Description ###
Oauth is used to allow users to interact with applications without having them to supply their username/password combination. Typical use cases include widgets, desktop apps and so on. For a more detailed explaination see [oauth.net](http://oauth.net/) :) It would also improve performance since you wouldn't need to request all resources using SSL.

**Update:** Instead of using OAuth, one could also use your session API to login and create an ID. This ID could be added into the next request to log someone in without Basic-Auth. The app would need to accept a cookie so for the next API calls, it could look for that cookie and authorize the call based on that. (Food for thought.)

### Why this would be useful ###
Users wouldn't need to give out the username/password to third-party apps


## Postcode / Address search for plaze ##

### Requested by Lance Wicks ###

### Feature Description ###
The ability to search for a plaze by postcode or street address.

### Why this would be useful ###
When building apps via the API we could find a plaze that pre exists at a physical location.

## Arbitrary environment information to improve suggestions ##
(suggested by til)

### Feature Description ###
Define a general way to describe arbitrary environmental data that a plazes client could potentially gather, in a format that is open so that it does not require changes on the Plazes API side to submit new kinds of data.

The Plazes API should be extended to accept this data on activity creation, and on requests to /plazes.xml to factor it into its computation of relevancy.

The format could be similar to flickr's machine tags which consists of a namespace, a key and a value.

Examples:

```
wlan:essid='My home router'
wlan:mac_address=00:15:F2:5B:7C:71
gsm:cell_id=5282
ip:address=83.199.11.12
or even something like this:
temperature:celsius=19
```

Submitting multiple values for the same namespace:key should be allowed, both when creating activities and when retrieving suggestions. The suggestions algorithm should use the given tags without requiring all of them, so that ie. a plaze created by an activity with

```
wlan:essid=A
wlan:essid=B
wlan:essid=C
```

would still be suggested for a request to /plazes.xml?wlan:essid=A&wlan:essid=B&wlan:essid=D

### Why this would be useful ###
It would open up the Plazes service for any kind network identifiers or potentially even other indicators from the environment about the current location of a user. For example a mobile plazer that uses wlan scanning to detect wlan networks in the proximity (which don't need to be open), or a mobile plazer when the phone API allows access to the cellid information.