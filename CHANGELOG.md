# Changelog

## v2.0.2 (6 April 2014)

* Added username postfix option.

## v2.0.1 (22 January 2014)

* Set Java SocketPermissions to `*` in Blackboard manifest, so we can connect to the MyTimetable API on non-standard ports.

## v2.0.0 (6 January 2014)

* Rebuild of initial building block, now using MyTimetable API
* Now includes a small REST web service that exports the enrollments of a user
* Switched to Gradle, removing support for Maven.
* Now using the MyTimetable API Client library.