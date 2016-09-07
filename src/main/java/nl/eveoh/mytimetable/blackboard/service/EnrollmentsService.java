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


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("user");
        String token = request.getHeader("apiToken");

        Configuration configuration = ConfigUtil.loadConfig();

        if (StringUtils.isBlank(token)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "API token required.");
            return;
        }

        if (configuration.getApiKey() == null) {
            log.error("API token has not been configured.");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "API token has not been configured.");
            return;
        } else if (!configuration.getApiKey().equals(token)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "API token invalid.");
            return;
        }

        User user;
        try {
            UserDbLoader userLoader = UserDbLoader.Default.getInstance();
            user = userLoader.loadByUserName(username);
        } catch (KeyNotFoundException e) {
            log.info("User could not be found.", e);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User could not be found.");
            return;
        } catch (PersistenceException e) {
            log.error("Error while loading user " + username + ".", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while loading user.");
            return;
        }

        List<CourseMembership> courseMemberships;
        try {
            CourseMembershipDbLoader membershipLoader = CourseMembershipDbLoader.Default.getInstance();
            courseMemberships = membershipLoader.loadByUserId(user.getId());
        } catch (PersistenceException e) {
            log.error("Error while loading course memberships for user " + username + "(" + user.getId() + ")" + ".", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while loading courses for user.");
            return;
        }

        CourseDbLoader courseLoader;
        try {
            courseLoader = CourseDbLoader.Default.getInstance();
        } catch (PersistenceException e) {
            log.error("Error while getting courseLoader.", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while loading courses for user.");
            return;
        }

        List<Enrollment> enrollments = new ArrayList<Enrollment>();
        for (CourseMembership membership : courseMemberships) {
            if (!membership.getIsAvailable()) {
                continue;
            }

            Enrollment enrollment = new Enrollment();

            try {
                enrollment.setCourse(new Course(courseLoader.loadById(membership.getCourseId())));
            } catch (PersistenceException e) {
                log.info("Error while loading course " + membership.getId() + " for user " + username + ".", e);
                continue;
            }

            enrollment.setEnrollmentDate((Calendar) membership.getEnrollmentDate().clone());

            enrollments.add(enrollment);
        }


        response.setContentType("application/json");
        mapper.writeValue(response.getOutputStream(), enrollments);
    }
}
