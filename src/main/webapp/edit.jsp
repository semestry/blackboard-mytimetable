<%@ page import="blackboard.portal.external.CustomData" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="/bbNG" prefix="bbNG" %>
<%@ taglib prefix="bbUI" uri="/bbUI" %>
<%@ taglib prefix="bbData" uri="/bbData" %>

<bbNG:modulePage type="personalize">

    <%
        CustomData cd = CustomData.getModulePersonalizationData(pageContext);
        String numberOfActivities = cd.getValue("numberOfActivities");

        if (numberOfActivities == null) {
            numberOfActivities = "5";
        }

    %>

    <bbNG:form action="personalizationService" id="configForm" name="configForm" method="post">

        <bbNG:dataCollection markUnsavedChanges="false" showSubmitButtons="true">
            <bbNG:step title="Application configuration"
                       instructions="Configure the full URL of MyTimetable and the number of events to be shown.">

                <bbNG:dataElement label="Number of events to show">
                    <input
                            type="number"
                            name="numberOfActivities"
                            value="<%= numberOfActivities %>"
                            min="1"/>
                </bbNG:dataElement>

            </bbNG:step>


            <bbNG:stepSubmit showCancelButton="false"/>
        </bbNG:dataCollection>
    </bbNG:form>

</bbNG:modulePage>
