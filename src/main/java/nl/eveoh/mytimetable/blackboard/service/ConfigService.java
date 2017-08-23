/*
 * Copyright 2013 - 2014 Eveoh
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package nl.eveoh.mytimetable.blackboard.service;

import com.google.common.base.Splitter;
import nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration;
import nl.eveoh.mytimetable.apiclient.service.MyTimetableServiceImpl;
import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import nl.eveoh.mytimetable.blackboard.MyTimetableServiceContainer;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        String applicationUriDescriptionOverride = request.getParameter("applicationUriDescriptionOverride");
        if (StringUtils.isBlank(applicationUriDescriptionOverride)) {
            applicationUriDescriptionOverride = null;
        }

        int numberOfEvents = -1;
        try {
            numberOfEvents = Integer.parseInt(request.getParameter("numberOfEvents"));
        } catch (NumberFormatException ex) {
            messages.put("numberOfEvents", "Please enter a valid number.");
        }

        int defaultNumberOfEvents = 5;
        try {
            defaultNumberOfEvents = Integer.parseInt(request.getParameter("defaultNumberOfEvents"));
        } catch (NumberFormatException ex) {
            messages.put("defaultNumberOfEvents", "Please enter a valid number.");
        }

        if (defaultNumberOfEvents > numberOfEvents) {
            messages.put("defaultNumberOfEvents",
                    "Default number of events should be less than the maximum number of events.");
        }

        String showActivityTypeString = request.getParameter("showActivityType");
        boolean showActivityType = showActivityTypeString != null && showActivityTypeString.equals("enable");

        String showCodeString = request.getParameter("showCode");
        boolean showCode = showCodeString != null && showCodeString.equals("enable");

        String showDescriptionString = request.getParameter("showDescription");
        boolean showDescription = showDescriptionString != null && showDescriptionString.equals("enable");

        String showStaffString = request.getParameter("showStaff");
        boolean showStaff = showStaffString != null && showStaffString.equals("enable");

        String showNote1String = request.getParameter("showNote1");
        boolean showNote1 = showNote1String != null && showNote1String.equals("enable");

        String showNote2String = request.getParameter("showNote2");
        boolean showNote2 = showNote2String != null && showNote2String.equals("enable");

        String showNote3String = request.getParameter("showNote3");
        boolean showNote3 = showNote3String != null && showNote3String.equals("enable");

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

        String useStudentIdString = request.getParameter("useStudentId");
        boolean useStudentId = useStudentIdString != null && useStudentIdString.equals("enable");

        String usernameDomainPrefix = request.getParameter("usernameDomainPrefix");
        if (StringUtils.isBlank(usernameDomainPrefix)) {
            usernameDomainPrefix = null;
        }

        String usernamePostfix = request.getParameter("usernamePostfix");
        if (StringUtils.isBlank(usernamePostfix)) {
            usernamePostfix = null;
        }

        String customCss = request.getParameter("customCss");
        if (StringUtils.isBlank(customCss)) {
            customCss = null;
        }

        String timetableTypes = request.getParameter("timetableTypes");

        String unknownLocationDescription = request.getParameter("unknownLocationDescription");
        if (StringUtils.isBlank(unknownLocationDescription)) {
            unknownLocationDescription = null;
        }
        request.setAttribute("messages", messages);
        request.setAttribute("targets", ConfigUtil.getHrefTargets());

        if (messages.isEmpty()) {
            // Save the configuration.

            try {
                saveConfig(applicationUri, selectedTarget, applicationUriDescriptionOverride, numberOfEvents,
                        defaultNumberOfEvents, showActivityType, showCode, showDescription, showStaff, showNote1,
                        showNote2, showNote3, apiEndpointUris, apiKey, apiSslCnCheck, apiConnectTimeout,
                        apiSocketTimeout, apiMaxConnections, useStudentId, usernameDomainPrefix, usernamePostfix,
                        customCss, timetableTypes, unknownLocationDescription);
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

    private void saveConfig(String applicationUri, String selectedTarget, String applicationUriDescriptionOverride,
                            int maxNumberOfEvents, int defaultNumberOfEvents, boolean showActivityType,
                            boolean showCode, boolean showDescription, boolean showStaff, boolean showNote1,
                            boolean showNote2, boolean showNote3, ArrayList<String> apiEndpointUris, String apiKey,
                            boolean apiSslCnCheck, int apiConnectTimeout, int apiSocketTimeout, int apiMaxConnections,
                            boolean useStudentId, String usernameDomainPrefix, String usernamePostfix, String customCss,
                            String timetableTypesStr, String unknownLocationDescription) {
        try {
            WidgetConfiguration configuration = ConfigUtil.loadConfig();

            configuration.setApplicationUri(applicationUri);
            configuration.setApplicationTarget(selectedTarget);
            configuration.setMaxNumberOfEvents(maxNumberOfEvents);
            configuration.setDefaultNumberOfEvents(defaultNumberOfEvents);
            configuration.setShowActivityType(showActivityType);
            configuration.setShowCode(showCode);
            configuration.setShowDescription(showDescription);
            configuration.setShowStaff(showStaff);
            configuration.setShowNote1(showNote1);
            configuration.setShowNote2(showNote2);
            configuration.setShowNote3(showNote3);
            configuration.setApiEndpointUris(apiEndpointUris);
            configuration.setApiKey(apiKey);
            configuration.setApiSslCnCheck(apiSslCnCheck);
            configuration.setApiConnectTimeout(apiConnectTimeout);
            configuration.setApiSocketTimeout(apiSocketTimeout);
            configuration.setApiMaxConnections(apiMaxConnections);
            configuration.setUseStudentId(useStudentId);
            configuration.setUsernameDomainPrefix(usernameDomainPrefix);
            configuration.setUsernamePostfix(usernamePostfix);
            configuration.setCustomCss(customCss);
            configuration.setUnknownLocationDescription(unknownLocationDescription);

            List<String> timetableTypes = new ArrayList<String>(
                    Splitter.on(';').trimResults().omitEmptyStrings().splitToList(timetableTypesStr));

            if (!timetableTypes.isEmpty()) {
                configuration.getTimetableTypes().clear();
                configuration.getTimetableTypes().addAll(timetableTypes);
            }

            configuration.setApplicationUriDescriptionOverride(applicationUriDescriptionOverride);

            ConfigUtil.saveConfig(configuration);

            MyTimetableServiceImpl service = MyTimetableServiceContainer.getService();
            service.onConfigurationChanged(configuration);
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
