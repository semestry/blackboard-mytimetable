/*
 * Eveoh MyTimetable, Web interface for timetables.
 *
 * Copyright (c) 2010 - 2013 Eveoh
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, see src/main/webapp/license/gpl-3.0.txt.
 * If not, see <http://www.gnu.org/licenses/>.
 */

package nl.eveoh.mytimetable.block.exception;

/**
 * A RuntimeException that can be internationalised.
 *
 * @author Marco Krikke
 */
public class LocalizableException extends RuntimeException {
    /**
     * Key as used in the resource bundle.
     *
     * Defaults to <tt>error</tt>.
     */
    private String resourceBundleKey = "error";

    /**
     * @see RuntimeException#RuntimeException(String)
     */
    public LocalizableException(String message) {
        super(message);
    }

    /**
     * @param resourceBundleKey Key used for translations.
     *
     * @see RuntimeException#RuntimeException(String)
     */
    public LocalizableException(String message, String resourceBundleKey) {
        super(message);
        this.resourceBundleKey = resourceBundleKey;
    }

    /**
     * @see RuntimeException#RuntimeException(String, Throwable)
     */
    public LocalizableException(String message, Throwable cause) {
        super(message, cause);
    }

    /**
     * @param resourceBundleKey Key used for translations.
     *
     * @see RuntimeException#RuntimeException(String, Throwable)
     */
    public LocalizableException(String message, Throwable cause, String resourceBundleKey) {
        super(message, cause);
        this.resourceBundleKey = resourceBundleKey;
    }

    public String getResourceBundleKey() {
        return resourceBundleKey;
    }

    public void setResourceBundleKey(String resourceBundleKey) {
        this.resourceBundleKey = resourceBundleKey;
    }
}