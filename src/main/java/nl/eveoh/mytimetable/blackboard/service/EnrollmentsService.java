package nl.eveoh.mytimetable.blackboard.service;

import blackboard.data.course.CourseMembership;
import blackboard.data.user.User;
import blackboard.persist.KeyNotFoundException;
import blackboard.persist.PersistenceException;
import blackboard.persist.course.CourseDbLoader;
import blackboard.persist.course.CourseMembershipDbLoader;
import blackboard.persist.user.UserDbLoader;
import com.fasterxml.jackson.databind.ObjectMapper;
import nl.eveoh.mytimetable.apiclient.configuration.Configuration;
import nl.eveoh.mytimetable.blackboard.ConfigUtil;
import nl.eveoh.mytimetable.blackboard.model.Course;
import nl.eveoh.mytimetable.blackboard.model.Enrollment;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * REST service for retrieving the courses a user has enrolled in.
 */
public class EnrollmentsService extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(EnrollmentsService.class);

    private static final ObjectMapper mapper = new ObjectMapper();



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("user");
        String token = request.getHeader("apiToken");

        Configuration configuration = ConfigUtil.loadConfig();

        if (StringUtils.isBlank(token)) {
            response.setStatus(HttpServletResponse.SC_PROXY_AUTHENTICATION_REQUIRED);
            return;
        }

        if (configuration.getApiKey() == null) {
            log.error("API token has not been configured.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        } else if (!configuration.getApiKey().equals(token)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        User user;
        try {
            UserDbLoader userLoader = UserDbLoader.Default.getInstance();
            user = userLoader.loadByUserName(username);
        } catch (KeyNotFoundException e) {
            log.info("User could not be found.", e);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        } catch (PersistenceException e) {
            log.error("Error while loading user.", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        List<CourseMembership> courseMemberships;
        try {
            CourseMembershipDbLoader membershipLoader = CourseMembershipDbLoader.Default.getInstance();
            courseMemberships = membershipLoader.loadByUserId(user.getId());
        } catch (PersistenceException e) {
            log.error("Error while loading courses for user.", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        CourseDbLoader courseLoader;
        try {
            courseLoader = CourseDbLoader.Default.getInstance();
        } catch (PersistenceException e) {
            log.error("Error while loading courses for user.", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        List<Enrollment> enrollments = new ArrayList<Enrollment>();
        for (CourseMembership membership : courseMemberships) {
            Enrollment enrollment = new Enrollment();

            try {
                enrollment.setCourse(new Course(courseLoader.loadById(membership.getCourseId())));
            } catch (PersistenceException e) {
                log.error("Error while loading courses for user.", e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return;
            }

            enrollment.setEnrollmentDate((Calendar) membership.getEnrollmentDate().clone());

            enrollments.add(enrollment);
        }


        response.setContentType("application/json");
        mapper.writeValue(response.getOutputStream(), enrollments);
    }
}
