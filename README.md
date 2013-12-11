videostore
==========

A gem for storing information about videos on remote streaming sites

Features:
- Currenty supports Youtube and Vimeo
- Methods for checking if they're still online
- Methods for bringing down up-to-date data from API #
- Various sorting options made possible through duck typing

To start using the gem have a file to the lib directory called keys.rb that defines 
YOUTUBE_DEVELOPER_KEY as your google developer key with access to the V3 Youtube API.

Instantiate a new Youtube video with
> VideoStore::Youtube.new(<insert youtube ID here>)

Do the same with Vimeo, but replace Youtube with Vimeo!!

Both classes respond to:
present?      -- Returns true if the video  
video_id      -- ID
uri           -- URI for the video
title         -- The Title
thumbnail_uri -- URI for the thumbnail
channel_name  -- Name of the poster of the video
views         -- # of views
likes         -- # of likes
comment_count -- # of comments
duration      -- length of the video in seconds

This duck typing allows you to sort both kinds of videos in the same collection.
