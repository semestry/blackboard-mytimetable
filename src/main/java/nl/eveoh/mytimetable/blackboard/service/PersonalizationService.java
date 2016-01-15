package nl.eveoh.mytimetable.blackboard.service;

import blackboard.data.ValidationException;
import blackboard.persist.PersistenceException;
import blackboard.portal.external.CustomData;
import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;

public class PersonalizationService extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(PersonalizationService.class);

    public static final String EDIT_JSP = "/edit.jsp";


//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        req.setAttribute("messages", new HashMap<String, String>());
//        req.setAttribute("targets", ConfigUtil.getHrefTargets());
//
//        req.getRequestDispatcher(EDIT_JSP).forward(req, resp);
//    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        CustomData cd;
        String numberOfActivities = req.getParameter("numberOfActivities");

        try {
            cd = CustomData.getModulePersonalizationData(req);
            cd.setValue("numberOfActivities", numberOfActivities);
            cd.save();
        } catch (PersistenceException e) {
            e.printStackTrace();
        } catch (ValidationException e) {
            e.printStackTrace();
        }

    }
}
