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

package nl.eveoh.mytimetable.blackboard.service;

import nl.eveoh.mytimetable.apiclient.service.MyTimetableServiceImpl;
import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 * Servlet that handles the POST request from the config.jsp page, and saves the configuration files to the Blackboard
 * building block configuration directory.
 * 
 * @author Mike Noordermeer
 * @author Marco Krikke
 * @author Erik van Paassen
 */
public class ConfigService extends HttpServlet {

    private static final long serialVersionUID = 8415424352054201389L;

    private static final Logger log = LoggerFactory.getLogger(ConfigService.class);

    public static final String CONFIG_JSP = "/config.jsp";



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("messages", new HashMap<String, String>());
        request.setAttribute("targets", ConfigUtil.getHrefTargets());
        request.setAttribute("configuration", ConfigUtil.loadConfig());

        request.getRequestDispatcher(CONFIG_JSP).forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ConfigUtil.authorizeUser(request, response);

        Map<String, String> messages = new HashMap<String, String>();

        String applicationUri = request.getParameter("applicationUri");
        if (StringUtils.isBlank(applicationUri)) {
            messages.put("applicationUri", "Please enter a URL.");
        }

        String target = request.getParameter("applicationTarget");
        Map<String, String> targets = ConfigUtil.getHrefTargets();
        String selectedTarget = targets.get(target);
        if (selectedTarget == null) {
            messages.put("applicationTarget", "Target should be set.");
        }

        int numberOfEvents = -1;
        try {
            numberOfEvents = Integer.parseInt(request.getParameter("numberOfEvents"));
        } catch (NumberFormatException ex) {
            messages.put("numberOfEvents", "Please enter a valid number.");
        }

        ArrayList<String> apiEndpointUris = new ArrayList<String>();
        String apiEndpointUrisString = request.getParameter("apiEndpointUris");
        if (StringUtils.isBlank(apiEndpointUrisString)) {
            messages.put("apiEndpointUris", "Please enter a URL.");
        } else {
            Scanner scanner = new Scanner(apiEndpointUrisString);
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();

                if (!line.isEmpty()) {
                    apiEndpointUris.add(line);
                }
            }
        }

        String apiKey = request.getParameter("apiKey");
        if (StringUtils.isBlank(apiKey)) {
            messages.put("apiKey", "Please enter a the API key.");
        }

        String apiSslCnCheckString = request.getParameter("apiSslCnCheck");
        boolean apiSslCnCheck = apiSslCnCheckString == null || !apiSslCnCheckString.equals("disable");

        int apiConnectTimeout = -1;
        try {
            apiConnectTimeout = Integer.parseInt(request.getParameter("apiConnectTimeout"));
        } catch (NumberFormatException ex) {
            messages.put("apiConnectTimeout", "Please enter a valid number.");
        }

        int apiSocketTimeout = -1;
        try {
            apiSocketTimeout = Integer.parseInt(request.getParameter("apiSocketTimeout"));
        } catch (NumberFormatException ex) {
            messages.put("apiSocketTimeout", "Please enter a valid number.");
        }

        int apiMaxConnections = -1;
        try {
            apiMaxConnections = Integer.parseInt(request.getParameter("apiMaxConnections"));
        } catch (NumberFormatException ex) {
            messages.put("apiMaxConnections", "Please enter a valid number.");
        }

        String usernameDomainPrefix = request.getParameter("usernameDomainPrefix");
        if (StringUtils.isBlank(usernameDomainPrefix)) {
            usernameDomainPrefix = null;
        }

        String customCss = request.getParameter("customCss");
        if (StringUtils.isBlank(customCss)) {
            customCss = null;
        }

        request.setAttribute("messages", messages);
        request.setAttribute("targets", ConfigUtil.getHrefTargets());

        if (messages.isEmpty()) {
            // Save the configuration.

            try {
                saveConfig(applicationUri, selectedTarget, numberOfEvents, apiEndpointUris, apiKey, apiSslCnCheck,
                        apiConnectTimeout, apiSocketTimeout, apiMaxConnections, usernameDomainPrefix, customCss);
            } catch (ConfigurationPersistenceException e) {
                log.error("Something went wrong with saving the preferences", e);

                messages.put("error", "Something went wrong with saving the preferences.");
                request.getRequestDispatcher(CONFIG_JSP).forward(request, response);
            } finally {
                ConfigUtil.redirectUser(response);
            }
        } else {
            request.getRequestDispatcher(CONFIG_JSP).forward(request, response);
        }
    }

    private void saveConfig(String applicationUri, String selectedTarget, int numberOfEvents,
                            ArrayList<String> apiEndpointUris, String apiKey, boolean apiSslCnCheck,
                            int apiConnectTimeout, int apiSocketTimeout, int apiMaxConnections,
                            String usernameDomainPrefix, String customCss) {
        try {
            WidgetConfiguration configuration = ConfigUtil.loadConfig();

            configuration.setApplicationUri(applicationUri);
            configuration.setApplicationTarget(selectedTarget);
            configuration.setNumberOfEvents(numberOfEvents);
            configuration.setApiEndpointUris(apiEndpointUris);
            configuration.setApiKey(apiKey);
            configuration.setApiSslCnCheck(apiSslCnCheck);
            configuration.setApiConnectTimeout(apiConnectTimeout);
            configuration.setApiSocketTimeout(apiSocketTimeout);
            configuration.setApiMaxConnections(apiMaxConnections);
            configuration.setUsernameDomainPrefix(usernameDomainPrefix);
            configuration.setCustomCss(customCss);

            ConfigUtil.saveConfig(configuration);

            MyTimetableServiceImpl.reinitializeHttpClient(configuration);
        } catch (NullPointerException e) {
            throw new ConfigurationPersistenceException(e);
        }
    }

    public static class ConfigurationPersistenceException extends RuntimeException {
        public ConfigurationPersistenceException(Throwable cause) {
            super(cause);
        }
    }
}