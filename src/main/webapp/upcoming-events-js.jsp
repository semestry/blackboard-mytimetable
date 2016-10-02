<script>
    /**
     * Resize handler that hides the type column when necessary, to allow for more space for the description column.
     */
    (function () {
        // Call the resizeThrottler on every resize event.
        window.addEventListener("resize", resizeThrottler, false);


        // Lock for the resizeThrottler.
        var resizeTimeout;

        // Threshold width of the description column.
        var descriptionColumnWidthThreshold = 100;

        // Width of the type column.
        var typeColumnWidth = getTypeColumnWidth();

        // State of the type column
        var isDisplayTypeColumn = true;

        // The description header element, used to calculate its width.
        var descriptionHeaderElement = document.getElementById('eveoh-mytimetable-description-header');

        // All elements in the type column.
        var typeElements;


        /**
         * Throttles calls to the actual resizeHandler.
         */
        function resizeThrottler() {
            // Ignore resize events as long as an resizeHandler execution is in the queue.
            if (!resizeTimeout) {
                resizeTimeout = setTimeout(function () {
                    resizeTimeout = null;
                    resizeHandler();

                    // The resizeHandler will execute at a rate of 15fps.
                }, 66);
            }
        }

        /**
         * Handles resize event.
         */
        function resizeHandler() {
            if (descriptionHeaderElement !== null && typeColumnWidth !== null) {
                var descriptionHeaderDOMRect = descriptionHeaderElement.getBoundingClientRect();

                // Subtract right from left, since IE8 does not support the width property.
                var descriptionHeaderWidth = descriptionHeaderDOMRect.right - descriptionHeaderDOMRect.left;

                if (descriptionHeaderWidth < descriptionColumnWidthThreshold && isDisplayTypeColumn === true) {
                    setTypeElementsVisibility(false);
                }
                // We add 2px to mitigate flickering around the threshold value due to rounding values.
                else if (descriptionHeaderWidth > descriptionColumnWidthThreshold + typeColumnWidth + 2 &&
                        isDisplayTypeColumn === false) {
                    setTypeElementsVisibility(true);
                }
            }
        }

        /**
         * Determines the width of the type column (fixed). Returns undefined when element does not exist.
         */
        function getTypeColumnWidth() {
            var typeHeaderElement = document.getElementById('eveoh-mytimetable-type-header');

            if (typeHeaderElement !== null) {
                var typeHeaderDOMRect = typeHeaderElement.getBoundingClientRect();

                // Subtract right from left, since IE8 does not support the width property.
                return typeHeaderDOMRect.right - typeHeaderDOMRect.left;
            }

            return undefined;
        }

        /**
         * Set visibility of type elements.
         *
         * @param show true when to show all type elements, false when to hide all type elements
         */
        function setTypeElementsVisibility(show) {
            // Initialise all elements in the type column.
            if (!typeElements) {
                var eventTableElement = document.getElementById('eveoh-mytimetable-event-table');

                if (eventTableElement !== null) {
                    typeElements = eventTableElement.getElementsByClassName('eveoh-mytimetable-type');
                }
                else {
                    typeElements = [];
                }
            }

            for (var i = 0; i < typeElements.length; i++) {
                typeElements[i].style.display = show ? '' : 'none'
            }

            isDisplayTypeColumn = show;
        }

        // Fire on-load. DOMContentLoaded event does not work, since Blackboard loads content via XHR.
        resizeHandler();
    }());
</script>