------------------------------------------------------------------------------------------
-- MailWhereAmI.applescript
--
-- Run this script and it will retrieve your current Plazes activity and create a 
-- new message, using Mail.app, with a customized signature.
--
-- Version:		0.1, January 14, 2008
-- Author: 		Peter Rukavina (mailto:peter@rukavina.net)
-- Copyright:	Copyright (c) 2008 by Reinvented Inc.
-- License:		http://www.fsf.org/licensing/licenses/gpl.txt GNU Public Licens
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or (at
-- your option) any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
-- USA
------------------------------------------------------------------------------------------

-- Plazes account information: enter your Plazes username and password here
property plazes_username : "ruk"
property plazes_password : "raichagout"

-- End of user-configurable parameters -- no need to change anything below unless you want
-- to customize the email signature that's created

if (plazes_username is "" or plazes_password is "") then
	display alert "You need to set your Plazes username and password in the AppleScript."
	return ""
else
	
	-- Grab an XML file from Plazes that reflects my current status and put it in /tmp/plazes.me.xml
	try
		do shell script "curl -s -u '" & plazes_username & ":" & plazes_password & "' -H 'Accept: application/xml' 'http://plazes.com/users/" & plazes_username & "/activity.xml' > /tmp/plazes.me.xml"
	on error errMsg number errNo
		display alert "Could not communicate with Plazes.com API"
	end try
	
	-- Use System Events' XML Suite to navigate the XML returned to grab the status and plaze
	tell application "System Events"
		try
			
			--this is where we saved the XML we got back from Plazes -- we morph it into an XML object
			set plazes_xmldata to XML file "/tmp/plazes.me.xml"
			
			-- the root element is <activity>
			set plaze_activity to XML element "activity" of plazes_xmldata
			
			-- the current status message is in child element <status>
			set current_status to value of XML element "status" of plaze_activity
			
			-- the root element is <plaze>
			set plaze_plaze to XML element "plaze" of plaze_activity
			
			--the plaze ID  is in child element <plaze_id>
			set plaze_id to value of XML element "plaze_id" of plaze_activity
			
			--the activity ID  is in child element <plaze_id>
			set activity_id to value of XML element "id" of plaze_activity
			
			set current_plaze to value of XML element "name" of plaze_plaze
			set current_city to value of XML element "city" of plaze_plaze
			set current_state to value of XML element "state" of plaze_plaze
			set current_country to value of XML element "country" of plaze_plaze
			set current_latitude to value of XML element "latitude" of plaze_plaze
			set current_longitude to value of XML element "longitude" of plaze_plaze
			set current_id to value of XML element "id" of plaze_plaze
			set current_url to "http://plazes.com/plazes/" & current_id
			
		on error errMsg number errNo
			-- If we couldn't retrieve plaze data, we set an empty status message
		end try
	end tell
	
	set messageText to "
---
Sent from " & current_plaze & " in " & current_city & ", " & current_country & " where I am " & current_status & "
" & "> LEARN  : http://plazes.com/plazes/" & plaze_id & "
" & "> COMMENT: http://plazes.com/activities/" & activity_id & "
" & "> CREATE : http://plazes.com/activities/new?activity%5Bplaze_id%5D=" & plaze_id & "
" & "> MAP    : http://maps.google.com/maps?q=" & ((round (current_latitude * 10000)) / 10000) & "," & ((round (current_longitude * 10000)) / 10000) & "
" & "> PHOTOS : http://flickr.com/search/?w=all&q=plazes%3Aid%3D" & plaze_id & "&m=tags
" & "> FOLLOW : http://plazes.com/users/" & plazes_username
	tell application "Mail"
		activate
		set newMessage to make new outgoing message with properties {content:messageText, visible:true}
	end tell
end if