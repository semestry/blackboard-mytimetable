package nl.eveoh.mytimetable.blackboard.model;

import java.io.Serializable;
import java.util.Calendar;

/**
 * @author Erik van Paassen
 */
public class Enrollment implements Serializable {

    private Course course;
    private Calendar enrollmentDate;

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Calendar getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(Calendar enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
}
