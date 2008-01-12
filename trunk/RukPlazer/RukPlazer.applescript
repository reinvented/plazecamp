------------------------------------------------------------------------------------------
-- RukPlazer.applescript
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- SET PROPERTIES
------------------------------------------------------------------------------------------

--We automatically assume this is the first time the app has been run by setting this property.  This may later be overridden by retrieving this property from the user defaults.
property firstrun : 1

--Plazes account information
property plazes_username : ""
property plazes_password : ""

--Retrieve user preferences on launch of app
on will finish launching theObject
	tell user defaults
		
		make new default entry at end of default entries with properties {name:"firstrun", contents:firstrun}
		
		make new default entry at end of default entries with properties {name:"plazes_username", contents:plazes_username}
		make new default entry at end of default entries with properties {name:"plazes_password", contents:plazes_password}
		
		set firstrun to contents of default entry "firstrun"
		
		set plazes_username to contents of default entry "plazes_username"
		set plazes_password to contents of default entry "plazes_password"
		
	end tell
end will finish launching

------------------------------------------------------------------------------------------
-- HANDLE THE CLICKS
------------------------------------------------------------------------------------------

--On launch, check to see if this is the first time we've run, and if it is then open the Preferences window
on launched theObject
	if firstrun is 1 then
		set preferencesWindow to makePreferencesWindow()
		tell preferencesWindow
			set visible to true
		end tell
	end if
end launched

--Handle clicks on buttons
on clicked theObject
	if name of theObject is "QuitButton" then
		tell me to quit
	else if name of theObject is "create_activity_button" then
		createActivity()
	else if name of theObject is "SaveButton" then
		savePreferences()
	end if
end clicked

--Handle menu selections
on choose menu item theObject
	if name of theObject is "PreferencesMenu" then
		openPreferences()
	end if
end choose menu item

------------------------------------------------------------------------------------------
-- PREFERENCES
------------------------------------------------------------------------------------------

--Populate and open the Preferences window
--Thanks to http://macscripter.net/articles/475_0_10_0_C/
on openPreferences()
	set preferencesWindow to makePreferencesWindow()
	tell preferencesWindow
		
		set contents of text field "PlazesUsername" to plazes_username
		set contents of text field "PlazesPassword" to plazes_password
		
		set visible to true
		
	end tell
end openPreferences

--Save the preferences as "user defaults"
--Thanks to http://macscripter.net/articles/475_0_10_0_C/
on savePreferences()
	
	set firstrun to 0
	
	set plazes_username to contents of text field "PlazesUsername" of window "PreferencesWindow"
	set plazes_password to contents of text field "PlazesPassword" of window "PreferencesWindow"
	
	tell user defaults
		set contents of default entry "firstrun" to 0
		
		set contents of default entry "plazes_username" to plazes_username
		set contents of default entry "plazes_password" to plazes_password
		
	end tell
	call method "synchronize" of object user defaults
	set visible of window "preferencesWindow" to false
end savePreferences

--Load the Preferences window
on makePreferencesWindow()
	load nib "PreferencesWindow"
	return window "PreferencesWindow"
end makePreferencesWindow

------------------------------------------------------------------------------------------
-- CREATE AN ACTIVITY
------------------------------------------------------------------------------------------

--Okay, this is the *actual* heavy lifting 
on createActivity()
	
	set status_field_message to ""
	set create_success to false
	
	if (plazes_username is "" or plazes_password is "") then
		set firstrun to 1
		openPreferences()
		return ""
	else
		
		start progress indicator "TheSpinner" of window "rukplazer_window"
		set contents of text field "StatusField" of window "rukplazer_window" to "Sending update to Plazes.com"
		
		set plaze_name to contents of text field "plaze_name" of window "rukplazer_window"
		set status_message to contents of text field "status_message" of window "rukplazer_window"
		
		-- Post to the Plazes API
		try
			do shell script "curl -s -u '" & plazes_username & ":" & plazes_password & "' -H 'Content-Type: application/xml' 'http://sandbox.plazes.com/activities.xml' -d \"" & escapequotes("<activity><plaze><name><![CDATA[\"" & plaze_name & "\"]]></name></plaze><status>" & status_message & "</status></activity>") & "\" > /tmp/plazes.create.xml"
			
		on error errMsg number errNo
			set contents of text field "StatusField" of window "rukplazer_window" to "Could not contact Plazes.com"
			log "Could not communicate with Plazes.com API"
		end try
		
		
		-- Use System Events' XML Suite to navigate the XML returned to grab the status and plaze
		tell application "System Events"
			try
				
				--this is where we saved the XML we got back from Plazes -- we morph it into an XML object
				set plazes_xmldata to XML file "/tmp/plazes.create.xml"
				
				-- <?xml version="1.0" encoding="UTF-8"?>
				-- <activity>
				--   <created_at type="datetime">2008-01-12T14:03:52Z</created_at>
				--   <device></device>
				--   <id>5983398</id>
				--   <plaze_id type="integer">87873</plaze_id>
				--   <status>now I need to figure out a way of adding pretty green \"yes\" or ugly green \"no\" graphic</status>
				--   <user_id type="integer">1185</user_id>
				--   <scheduled_at type="datetime">2008-01-12T15:03:51+01:00</scheduled_at>
				-- </activity>
				
				-- the root element is <activity>
				set plaze_activity to XML element "activity" of plazes_xmldata
				
				-- the new activity ID is in child element <id>
				set activity_id to value of XML element "id" of plaze_activity
				set status_field_message to "Activity created"
				set create_success to true
				
				
			on error errMsg number errNo
				set status_field_message to "Activity NOT created"
				set create_success to false
				
			end try
		end tell
		
		set contents of text field "StatusField" of window "rukplazer_window" to status_field_message
		set contents of text field "status_message" of window "rukplazer_window" to ""
		stop progress indicator "TheSpinner" of window "rukplazer_window"
		
		if create_success is false then
			display alert "Activity Not created" as critical message "Your activity could not be created - you must enter an existing Plaze name"
		end if
		
		
	end if
end createActivity

------------------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
------------------------------------------------------------------------------------------

to encodeTextUTF8(k)
	set k to escapequotes(k)
	set command to "/usr/bin/php -r \"print urlencode(\\\"" & k & "\\\");\""
	set utftext to (do shell script command)
end encodeTextUTF8

--Escape a chunk of text for passing to the command line
on escapequotes(theText)
	set theTextEnc to ""
	repeat with eachChar in characters of theText
		set useChar to eachChar
		set eachCharNum to ASCII number of eachChar
		if eachCharNum = 34 then
			set useChar to "\\\\\\\""
		end if
		set theTextEnc to theTextEnc & useChar as string
	end repeat
	return theTextEnc
end escapequotes

on simpleReplace(search, replace, subject)
	local search, replace, subject, ASTID
	
	set ASTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to search
	set subject to text items of subject
	
	set AppleScript's text item delimiters to replace
	set subject to "" & subject
	set AppleScript's text item delimiters to ASTID
	
	return subject
end simpleReplace



