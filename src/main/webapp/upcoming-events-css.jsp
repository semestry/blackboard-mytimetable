<style>
#eveoh-mytimetable-container {
    width: 100%;
}

.eveoh-mytimetable-hidden {
    display: none;
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
    border-top: 1px solid #ccc;
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event {
    padding-left: 0;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type {
    width: 60px;
    min-width: 60px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-date {
    width: 40px;
    min-width: 40px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-time {
    width: 80px;
    min-width: 80px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location {
    width: 30%;
    min-width: 30%;
    padding-right: 0;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location span {
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
    display: block;
}

.eveoh-mytimetable-error-header {
    font-weight: bold;
    padding-bottom: 5px;
}
</style>