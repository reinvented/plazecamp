## Plazes 

&lt;-&gt;

 Upcoming Hack ##

[LanceW](mailto:lw@judocoach.com)

Use your present Plaze location to search for events on upcoming org (xml output) [Example ](http://www.lancewicks.com/plazecamp2008/plazes1.php) /  [Source PHP](http://www.lancewicks.com/plazecamp2008/plazes1.txt)

This quick hack outputs XML (so look at the source of the page produced), needs tidying up (i.e. does not filter dates.

Use your present Plaze location to search for events on upcoming org (html output) [Example ](http://www.lancewicks.com/plazecamp2008/plazes2.php) /  [Source PHP](http://www.lancewicks.com/plazecamp2008/plazes2.txt)

Quick page of upcoming events on eventful within a 20 miles of your current plaze in the next day.


There is a config file called plz\_conf.php that contains:
```
<?php
// config file
$plz_id="user";
$plz_pass="pass";
$api_upcoming = "key from Yahoo";
?>
```

## Wii Plazer ##

http://ruk.ca/wii

## Plazes + Mail.app ##

I've created an
[AppleScript](http://plazecamp.googlecode.com/svn/trunk/AppleScript/MailWhereAmI.applescript) that creates a new Mail.app message with a signature containing information relevant to the current Plazes activity.