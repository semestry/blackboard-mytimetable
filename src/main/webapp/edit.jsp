<%@ page import="blackboard.portal.external.CustomData" %>
<%@ page import="nl.eveoh.mytimetable.apiclient.configuration.Configuration" %>
<%@ page import="nl.eveoh.mytimetable.blackboard.ConfigUtil" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="/bbNG" prefix="bbNG" %>
<%@ taglib prefix="bbUI" uri="/bbUI" %>
<%@ taglib prefix="bbData" uri="/bbData" %>

<bbNG:modulePage type="personalize">

    <style type="text/css">
        .error {
            color: red;
        }
    </style>

    <%
        CustomData cd = CustomData.getModulePersonalizationData(pageContext);
        String numberOfActivities = cd.getValue("numberOfActivities");

        Configuration configuration = ConfigUtil.loadConfig();

        int maxNumberOfActivities = configuration.getMaxNumberOfEvents();

        if (numberOfActivities == null) {
            numberOfActivities = String.valueOf(configuration.getDefaultNumberOfEvents());
        }

        Map<String, String> messages = (Map<String, String>) request.getAttribute("messages");
        pageContext.setAttribute("messages", messages);

    %>

    <bbNG:form action="personalizationService" id="configForm" name="configForm" method="post">

        <div class="error">${messages.error}</div>

        <bbNG:dataCollection markUnsavedChanges="false" showSubmitButtons="true">
            <bbNG:step title="Application configuration"
                       instructions="Configure the full URL of MyTimetable and the number of events to be shown.">

                <bbNG:dataElement label="Number of events to show">
                    <input
                            type="number"
                            name="numberOfActivities"
                            value="<%= numberOfActivities %>"
                            min="1"
                            max="<%= maxNumberOfActivities %>"/>
                </bbNG:dataElement>

            </bbNG:step>


            <bbNG:stepSubmit showCancelButton="false"/>
        </bbNG:dataCollection>
    </bbNG:form>

</bbNG:modulePage>
