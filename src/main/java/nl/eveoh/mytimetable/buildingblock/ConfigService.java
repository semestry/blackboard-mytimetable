/*
 * Eveoh MyTimetable, Webinterface for Scientia Syllabus Plus schedules.
 * 
 * Copyright (c) 2010 - 2011,
 * Marco Krikke <marco@eveoh.nl>
 * Mike Noordermeer <mike@eveoh.nl>
 * Tom Verhoeff <tom@eveoh.nl>
 * Maarten van der Beek <maarten@ch.tudelft.nl>
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
 * along with this program, see war/license/gpl-3.0.txt.
 * If not, see <http://www.gnu.org/licenses/>.
 */

package nl.eveoh.mytimetable.buildingblock;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import blackboard.persist.PersistenceException;
import blackboard.platform.LicenseUtil;

/**
 * Servlet that handles the POST request from the config.jsp page, and saves the
 * configuration files to the Blackboard building block configuration directory.
 * 
 * @author Mike Noordermeer
 * @author Marco Krikke
 */
public class ConfigService extends HttpServlet {

    private static final long serialVersionUID = 8415424352054201356L;

    private static final Logger log = LoggerFactory.getLogger(ConfigService.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("messages", new HashMap<String, String>());
        request.setAttribute("targets", ConfigUtil.getHrefTargets());
        request.setAttribute("configuration", ConfigUtil.loadConfig());

        request.getRequestDispatcher(getConfigJspUrl()).forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ConfigUtil.authorizeUser(request, response);

        Map<String, String> messages = new HashMap<String, String>();

        // get the full MyTimetable URL
        String fullUrl = request.getParameter("mytimetable_full_url");
        if (fullUrl == null || fullUrl.trim().isEmpty()) {
            messages.put("mytimetable_full_url", "Please enter an URL.");
        }

        // get the URL target
        String target = request.getParameter("mytimetable_target");
        Map<String, String> targets = ConfigUtil.getHrefTargets();
        String selectedTarget = targets.get(target);
        if (selectedTarget == null) {
            messages.put("mytimetable_target", "Target should be entered.");
        }

        // get the number of activities
        String numberOfActivities = "";
        try {
            Integer.parseInt(request.getParameter("number_of_activities"));
            numberOfActivities = request.getParameter("number_of_activities");
        }
        catch (NumberFormatException ex) {
            messages.put("number_of_activities", "Please enter a valid number.");
        }

        // get the WS address
        String webserviceUrl = request.getParameter("mytimetable_web_service_url");
        if (webserviceUrl == null || webserviceUrl.trim().isEmpty()) {
            messages.put("mytimetable_web_service_url", "Please enter an URL.");
        }

        // get the shared secret
        String sharedSecret = request.getParameter("mytimetable_web_service_shared_secret");
        if (sharedSecret == null || sharedSecret.trim().isEmpty()) {
            messages.put("mytimetable_web_service_shared_secret", "Please enter a shared secret.");
        }

        // get the domain prefix
        String domainPrefix = request.getParameter("mytimetable_domain_prefix");

        request.setAttribute("messages", messages);
        request.setAttribute("targets", ConfigUtil.getHrefTargets());

        if (messages.isEmpty()) {
            // save the configuration to the server
            Properties configuration = ConfigUtil.loadConfig();

            try {
                configuration.setProperty("mytimetable_full_url", fullUrl);
                configuration.setProperty("mytimetable_target", selectedTarget);
                configuration.setProperty("number_of_activities", numberOfActivities);
                configuration.setProperty("mytimetable_web_service_url", webserviceUrl);
                configuration.setProperty("mytimetable_web_service_shared_secret", sharedSecret);

                if (domainPrefix == null || domainPrefix.trim().isEmpty()) {
                    configuration.setProperty("mytimetable_domain_prefix", "");
                }
                else {
                    configuration.setProperty("mytimetable_domain_prefix", domainPrefix);
                }

                ConfigUtil.saveConfig(configuration);
            }
            catch (NullPointerException ex) {
                log.error("Something went wrong with saving the preferences", ex);

                messages.put("error", "Something went wrong with saving the preferences.");
                request.getRequestDispatcher(getConfigJspUrl()).forward(request, response);
            }
            finally {
                ConfigUtil.redirectUser(response);
            }
        }
        else {
            request.getRequestDispatcher(getConfigJspUrl()).forward(request, response);
        }
    }

    private String getConfigJspUrl() {
        String buildNumber;
        try {
            buildNumber = LicenseUtil.getBuildNumber();
        }
        catch (PersistenceException e) {
            return "/config.jsp";
        }

        if (LicenseUtil.getMajorReleaseNumber(buildNumber).equals("8")) {
            return "/config8.jsp";
        }
        else {
            return "/config.jsp";
        }
    }
}
