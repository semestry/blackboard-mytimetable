/*
 * Eveoh MyTimetable, Webinterface for Scientia Syllabus Plus schedules.
 * 
 * Copyright (c) 2010 - 2011, 
 * Marco Krikke         <marco@eveoh.nl>
 * Mike Noordermeer     <mike@eveoh.nl>
 * Tom Verhoeff         <tom@eveoh.nl>
 * Maarten van der Beek <maarten@ch.tudelft.nl>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program, see war/license/gpl-3.0.txt. 
 * If not, see <http://www.gnu.org/licenses/>.
 */
package nl.eveoh.mytimetable.buildingblock;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.PropertyConfigurator;

/**
 * Configures log4j by explicitely reading the log4j.properties file (in
 * WEB-INF/classes).
 * 
 * @author Mike Noordermeer
 * 
 */
public class Log4jInitListener implements ServletContextListener {

    public void contextInitialized(ServletContextEvent event) {
        PropertyConfigurator.configure(event.getServletContext().getRealPath("WEB-INF/classes/log4j.properties"));
    }

    public void contextDestroyed(ServletContextEvent event) {

    }

}
