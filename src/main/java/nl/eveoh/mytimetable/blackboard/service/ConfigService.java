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

import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import nl.eveoh.mytimetable.block.model.Configuration;
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

    private static final long serialVersionUID = 8415424352054201386L;

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
        if (applicationUri == null || applicationUri.trim().isEmpty()) {
            messages.put("applicationUri", "Please enter a URL.");
        }

        String target = request.getParameter("applicationTarget");
        Map<String, String> targets = ConfigUtil.getHrefTargets();
        String selectedTarget = targets.get(target);
        if (selectedTarget == null) {
            messages.put("applicationTarget", "Target should be entered.");
        }

        int numberOfEvents = -1;
        try {
            numberOfEvents = Integer.parseInt(request.getParameter("numberOfEvents"));
        } catch (NumberFormatException ex) {
            messages.put("numberOfEvents", "Please enter a valid number.");
        }

        ArrayList<String> apiEndpointUris = new ArrayList<String>();
        String apiEndpointUrisString = request.getParameter("apiEndpointUris");
        if (apiEndpointUrisString == null || apiEndpointUrisString.trim().isEmpty()) {
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
        if (apiKey == null || apiKey.trim().isEmpty()) {
            messages.put("apiKey", "Please enter a the API key.");
        }

        String sslNameCheckString = request.getParameter("sslNameCheck");
        boolean sslNameCheck = sslNameCheckString == null || !sslNameCheckString.equals("disable");

        String usernameDomainPrefix = request.getParameter("usernameDomainPrefix");
        if (usernameDomainPrefix.trim().isEmpty()) {
            usernameDomainPrefix = null;
        }

        request.setAttribute("messages", messages);
        request.setAttribute("targets", ConfigUtil.getHrefTargets());

        if (messages.isEmpty()) {
            // save the configuration to the server
            Configuration configuration = ConfigUtil.loadConfig();

            try {
                configuration.setApplicationUri(applicationUri);
                configuration.setApplicationTarget(selectedTarget);
                configuration.setNumberOfEvents(numberOfEvents);
                configuration.setApiEndpointUris(apiEndpointUris);
                configuration.setApiKey(apiKey);
                configuration.setSslNameCheck(sslNameCheck);
                configuration.setUsernameDomainPrefix(usernameDomainPrefix);

                ConfigUtil.saveConfig(configuration);
            } catch (NullPointerException ex) {
                log.error("Something went wrong with saving the preferences", ex);

                messages.put("error", "Something went wrong with saving the preferences.");
                request.getRequestDispatcher(CONFIG_JSP).forward(request, response);
            } finally {
                ConfigUtil.redirectUser(response);
            }
        } else {
            request.getRequestDispatcher(CONFIG_JSP).forward(request, response);
        }
    }
}