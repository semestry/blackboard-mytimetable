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

table.eveoh-mytimetable-upcoming-events td {
    vertical-align: top;
}

table.eveoh-mytimetable-upcoming-events th {
    font-weight: bold;
    border-bottom: 1px solid #ccc;
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-code {
    width: 120px;
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event {
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type {
    width: 70px;
    min-width: 70px;
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
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-staff {
}

table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-code span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location span,
table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-staff span {
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
    -ms-text-overflow: ellipsis;
    display: block;
}

table.eveoh-mytimetable-upcoming-events span.inline {
    display: inline;
}

.eveoh-mytimetable-error-header {
    font-weight: bold;
    padding-bottom: 5px;
}

/* Hide type column when screen size is too small. */
/* Breakpoint is based on the default 3-column layout of Blackboard, where this building block is loaded in one of the */
/* larger columns. */
@media only screen and (max-width: 768px) {
    table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-time {
        width: 40px;
        min-width: 40px;
    }

    table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-time-end {
        display: none;
    }
}

@media only screen and (max-width: 1380px) {
    table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type {
        display: none;
    }
}

@media only screen and (max-width: 1920px) {
    table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-staff {
        display: none;
    }
}
</style>
