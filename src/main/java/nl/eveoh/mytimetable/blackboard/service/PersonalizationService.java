package nl.eveoh.mytimetable.blackboard.service;

import blackboard.data.ValidationException;
import blackboard.persist.PersistenceException;
import blackboard.portal.external.CustomData;
import nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration;
import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class PersonalizationService extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(PersonalizationService.class);

    public static final String EDIT_JSP = "edit.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        WidgetConfiguration configuration = ConfigUtil.loadConfig();

        CustomData cd;
        String numberOfActivitiesString = req.getParameter("numberOfActivities");

        int numberOfActivities = Integer.parseInt(numberOfActivitiesString);

        if (numberOfActivities < 0 || numberOfActivities > configuration.getMaxNumberOfEvents()) {
            numberOfActivities = configuration.getDefaultNumberOfEvents();
        }

        Map<String, String> messages = new HashMap<String, String>();

        try {
            cd = CustomData.getModulePersonalizationData(req);
            cd.setValue("numberOfActivities", String.valueOf(numberOfActivities));
            cd.save();
        } catch (PersistenceException e) {
            handleException(req, resp, messages, e);
        } catch (ValidationException e) {
            handleException(req, resp, messages, e);
        } finally {
            resp.sendRedirect("/");
        }

    }

    private void handleException(HttpServletRequest req, HttpServletResponse resp, Map<String, String> messages, Exception e) throws ServletException, IOException {
        log.error("Something went wrong with saving the preferences", e);

        messages.put("error", "Something went wrong with saving the preferences.");
        req.setAttribute("messages", messages);

        req.getRequestDispatcher(EDIT_JSP).forward(req, resp);
    }
}
