<style>
    /* Customer specific CSS */

    @media only screen and (max-width: 1920px) {
        /* Hide module name on smaller screens */
        table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-event {
            display: none;
        }

        /* Show notes with module code, instead of module name */
        table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-code .eveoh-mytimetable-code-notes {
            display: inline;
        }
    }

    @media only screen and (max-width: 480px) {
        /* Hide location on mobile-grade screens */
        table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-location {
            display: none;
        }

        /* Display type on mobile-grade screens */
        table.eveoh-mytimetable-upcoming-events .eveoh-mytimetable-type {
            display: table-cell;
        }
    }
</style>
