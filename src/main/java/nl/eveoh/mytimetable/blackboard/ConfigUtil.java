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
package nl.eveoh.mytimetable.blackboard;

import blackboard.data.navigation.NavigationItem;
import blackboard.persist.navigation.NavigationItemDbLoader;
import blackboard.platform.plugin.PlugInConfig;
import blackboard.platform.plugin.PlugInUtil;
import blackboard.platform.servlet.InlineReceiptUtil;
import nl.eveoh.mytimetable.apiclient.configuration.Configuration;
import nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Helper methods for {@link nl.eveoh.mytimetable.blackboard.service.ConfigService}.
 * 
 * @author Marco Krikke
 */
public abstract class ConfigUtil {

    /**
     * Filename of the config file.
     */
    private static String CONFIG_FILE = "config.properties";

    private static final Logger log = LoggerFactory.getLogger(ConfigUtil.class);



    /**
     * Returns the targets for the full schedule link
     * 
     * @return                  Targets for the full schedule link
     */
    public static Map<String, String> getHrefTargets() {
        // use a LinkedHashMap to maintain the order of insertion
        Map<String, String> targets = new LinkedHashMap<String, String>();
        targets.put("_top", "_top");
        targets.put("_blank", "_blank");

        return targets;
    }

    /**
     * Saves the configuration to the configuration file.
     *
     * @param configuration     Properties file with the configuration
     */
    public static void saveConfig(Configuration configuration) {
        BufferedWriter out;

        Properties properties = configuration.toProperties();

        try {
            PlugInConfig pc = new PlugInConfig("evh", "mytimetable-b2");

            out = new BufferedWriter(new FileWriter(pc.getConfigDirectory().getAbsolutePath() + "/" + CONFIG_FILE));
        } catch (Exception ex) {
            log.error("Could not open plugin configuration for saving", ex);
            return;
        }

        try {
            properties.store(out, "MyTimetable upcoming events configuration.");
        } catch (Exception ex) {
            log.error("Could not save plugin configuration", ex);
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                log.error("Unknown I/O error", e);
            }
        }

    }

    /**
     * Loads the configuration from the configuration file.
     * 
     * @return                  Properties file containing the configuration.
     */
    public static WidgetConfiguration loadConfig() {
        BufferedReader in;
        Properties properties = new Properties();

        try {
            PlugInConfig pc = new PlugInConfig("evh", "mytimetable-b2");

            in = new BufferedReader(new FileReader(pc.getConfigDirectory().getAbsolutePath() + "/" + CONFIG_FILE));
        } catch (Exception ex) {
            log.error("Could not open plugin configuration for saving", ex);
            return new WidgetConfiguration();
        }

        try {
            properties.load(in);
        } catch (Exception ex) {
            log.error("Could not load plugin configuration", ex);
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                log.error("Unknown I/O error", e);
            }
        }

        return new WidgetConfiguration(properties);
    }

    /**
     * Checks if the Blackboard user is authorized for the system administration panel.
     * 
     * @param request           {@link HttpServletRequest} belonging to the current request.
     * @param response          {@link HttpServletResponse} belonging to the current request.
     */
    public static void authorizeUser(HttpServletRequest request, HttpServletResponse response) {
        // Check user permissions
        try {
            PlugInUtil.authorizeForSystemAdmin(request, response);
        } catch (Throwable ex) {
            log.warn("Could not authorize user.", ex);
            throw new RuntimeException("Could not authorize user.");
        }
    }

    /**
     * Redirects the user back the the manage plugins page, with a 'configuration saved' message.
     * 
     * @param response          {@link HttpServletResponse} belonging to the current request.
     * @throws IOException      if the redirect cannot be executed.
     */
    public static void redirectUser(HttpServletResponse response) throws IOException {
        StringBuffer returnUrl = new StringBuffer("");
        // generate a final cancelUrl
        try {
            NavigationItemDbLoader niLoader = NavigationItemDbLoader.Default.getInstance();
            NavigationItem navItem = niLoader.loadByInternalHandle("admin_plugin_manage");
            returnUrl.append(navItem.getHref());
        } catch (blackboard.persist.KeyNotFoundException kE) {
            returnUrl.append("/webapps/blackboard/admin/manage_plugins.jsp");
        } catch (blackboard.persist.PersistenceException pE) {
            returnUrl.append("/webapps/blackboard/admin/manage_plugins.jsp");
        }

        returnUrl.append("?");
        returnUrl.append(InlineReceiptUtil.SIMPLE_STRING_KEY);
        returnUrl.append("=");
        returnUrl.append("Configuration saved.");
        response.sendRedirect(returnUrl.toString());
    }
}
