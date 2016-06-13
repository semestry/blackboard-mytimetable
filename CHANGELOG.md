# Changelog

## v2.1.3 (13 June 2016)

* Show title for event description and type.
* Retrieve API response in Blackboard locale.
* Translated user settings page.
* Fixed check on "number of activities to show" setting (could be 0).
* Localised manifest.
* Hide type column at a threshold value to allow for enough space for the description column.

## v2.1.2 (8 March 2016)

* Fixed number of activities validation in admin settings.
* Fall back to default number of activities (set by admin) if an invalid number of activities is set by the user.

## v2.1.1 (24 February 2016)

* Prevent IndexOutOfBoundsException when sublisting the number of activities to show.
* Apply styling when displaying in IE compatibility mode (#8).
* Minor styling fixes for Blackboard 9.
* Removed Firefox 3 support.

## v2.1.0 (22 January 2016)

* Show activity type column (configurable).
* Make number of activities shown user configurable.
* Make 'unknown location' message configurable.

## v2.0.5 (5 March 2015)

* Fixed width of the timetable types column on the configuration page.

## v2.0.4 (4 March 2015)

* Disabled SSLv2Hello/SSLv3 support.

## v2.0.3 (11 December 2014)

* Added timetable types option.

## v2.0.2 (6 April 2014)

* Added username postfix option.

## v2.0.1 (22 January 2014)

* Set Java SocketPermissions to `*` in Blackboard manifest, so we can connect to the MyTimetable API on non-standard ports.

## v2.0.0 (6 January 2014)

* Rebuild of initial building block, now using MyTimetable API.
* Now includes a small REST web service that exports the enrollments of a user.
* Switched to Gradle, removing support for Maven.
* Now using the MyTimetable API Client library.