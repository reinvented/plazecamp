Following the [Flickr documentation for machine tag format](http://www.flickr.com/groups/api/discuss/72157594497877875) I propose the following be the standard for tagging Flickr photos with information about their Plaze:

**plazes:id`=[`plaze\_id`]`**

Tag a photo with the Plaze it's taken at (or taken of).

For example:

`plazes:id=87873`

http://flickr.com/search/?w=all&q=plazes%3Aid%3D87873&m=tags

**plazes:activity\_id`=[`activity\_id`]`**

Tag a photo with the Plazes Activity it's taken at (or taken of).

For example:

`plazes:activity_id=5841109`

http://flickr.com/search/?w=all&q=plazes%3Aactivity_id%3D5841109&m=tags

**plazes:user\_id`=[`user\_id`]`**

Tag a photo with the Plazes user(s) it's taken of.

For example:

`plazes:user_id=1`

http://flickr.com/search/?w=all&q=plazes%3Auser_id%3D1&m=tags