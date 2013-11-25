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

package nl.eveoh.mytimetable.block.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;
import java.util.List;

/**
 * A timetable event.
 *
 * @author Marco Krikke
 */
public class Event {
    /**
     * Description of the activity.
     */
    @JsonProperty(required = true)
    private String activityDescription;

    /**
     * Start date of the activity.
     */
    @JsonProperty(required = true)
    private Date startDate;

    /**
     * End date of the activity.
     */
    @JsonProperty(required = true)
    private Date endDate;

    /**
     * List of locations for this activity.
     */
    @JsonProperty(required = true)
    private List<Location> locations;

    public Event() {
    }

    public Event(String activityDescription, Date startDate, Date endDate, List<Location> locations) {
        this.activityDescription = activityDescription;
        this.startDate = startDate;
        this.endDate = endDate;
        this.locations = locations;
    }

    public String getActivityDescription() {
        return activityDescription;
    }

    public void setActivityDescription(String activityDescription) {
        this.activityDescription = activityDescription;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public List<Location> getLocations() {
        return locations;
    }

    public void setLocations(List<Location> locations) {
        this.locations = locations;
    }
}
