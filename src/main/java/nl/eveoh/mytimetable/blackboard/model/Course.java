package nl.eveoh.mytimetable.blackboard.model;

import java.io.Serializable;
import java.util.Calendar;

/**
 * @author Erik van Paassen
 */
public class Course implements Serializable {

    private String id;
    private String title;
    private String displayTitle;
    private String description;
    private String institutionName;
    private String serviceLevel;
    private boolean available;
    private boolean organization;
    private Calendar startDate;
    private Calendar endDate;



    public Course() {}

    public Course(blackboard.data.course.Course bbCourse) {
        this.id = bbCourse.getCourseId();
        this.title = bbCourse.getTitle();
        this.displayTitle = bbCourse.getDisplayTitle();
        this.description = bbCourse.getDescription();
        this.institutionName = bbCourse.getInstitutionName();
        this.available = bbCourse.getIsAvailable();
        this.organization = bbCourse.isOrganization();
        this.serviceLevel = bbCourse.getServiceLevelType().toFieldName();

        if (bbCourse.getStartDate() != null) {
            this.startDate = (Calendar) bbCourse.getStartDate().clone();
        }
        if (bbCourse.getEndDate() != null) {
            this.endDate = (Calendar) bbCourse.getEndDate().clone();
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDisplayTitle() {
        return displayTitle;
    }

    public void setDisplayTitle(String displayTitle) {
        this.displayTitle = displayTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getInstitutionName() {
        return institutionName;
    }

    public void setInstitutionName(String institutionName) {
        this.institutionName = institutionName;
    }

    public String getServiceLevel() {
        return serviceLevel;
    }

    public void setServiceLevel(String serviceLevel) {
        this.serviceLevel = serviceLevel;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public boolean isOrganization() {
        return organization;
    }

    public void setOrganization(boolean organization) {
        this.organization = organization;
    }

    public Calendar getStartDate() {
        return startDate;
    }

    public void setStartDate(Calendar startDate) {
        this.startDate = startDate;
    }

    public Calendar getEndDate() {
        return endDate;
    }

    public void setEndDate(Calendar endDate) {
        this.endDate = endDate;
    }
}