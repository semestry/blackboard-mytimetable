<style>
#eveoh-mytimetable-container {
    width: 100%;
}

table.eveoh-mytimetable-upcoming-events {
    width: 100%;
    margin-bottom: 5px;
    table-layout: fixed;
    white-space: nowrap;
}

table.eveoh-mytimetable-upcoming-events th,
table.eveoh-mytimetable-upcoming-events td {
    padding: 5px;
}

table.eveoh-mytimetable-upcoming-events th {
    font-weight: bold;
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
    -moz-binding: url('xml/ff_ellipsis.xml#ellipsis'); /* Fix for FF 3.x, fixed in FF7 (https://bugzilla.mozilla.org/show_bug.cgi?id=312156) */
}

table.eveoh-mytimetable-upcoming-events td {
    border-top: 1px dotted #eee;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event {
    padding-left: 0;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-date {
    width: 30px;
    min-width: 30px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-time {
    width: 70px;
    min-width: 70px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location {
    width: 30%;
    min-width: 30%;
    padding-right: 0;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location span {
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
    -moz-binding: url('xml/ff_ellipsis.xml#ellipsis'); /* Fix for FF 3.x, fixed in FF7 (https://bugzilla.mozilla.org/show_bug.cgi?id=312156) */
    display: block;
}

.eveoh-mytimetable-error-header {
    font-weight: bold;
    padding-bottom: 5px;
}
</style>