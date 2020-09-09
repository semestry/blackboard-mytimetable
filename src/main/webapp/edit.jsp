<%@ page import="blackboard.portal.external.CustomData" %>
<%@ page import="nl.eveoh.mytimetable.apiclient.configuration.Configuration" %>
<%@ page import="nl.eveoh.mytimetable.blackboard.ConfigUtil" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.text.MessageFormat" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="/bbNG" prefix="bbNG" %>
<%@taglib prefix="bbData" uri="/bbData" %>

<bbNG:modulePage type="personalize">
    <style type="text/css">
        .error {
            color: red;
        }
    </style>

    <%
        Configuration configuration = ConfigUtil.loadConfig();
        CustomData cd = CustomData.getModulePersonalizationData(pageContext);

        int maxNumberOfActivities = configuration.getMaxNumberOfEvents();
        Integer numberOfActivities = null;

        try {
            numberOfActivities = Integer.parseInt(cd.getValue("numberOfActivities"));
        } catch (NumberFormatException ignored) {
        }

        if (numberOfActivities == null || maxNumberOfActivities < numberOfActivities) {
            numberOfActivities = configuration.getDefaultNumberOfEvents();
        }

        Map<String, String> messages = (Map<String, String>) request.getAttribute("messages");
        pageContext.setAttribute("messages", messages);

        ResourceBundle rb = ResourceBundle.getBundle("BlackboardMessagesBundle");

        pageContext.setAttribute("step1Title", rb.getString("Edit_Step_1_Title"));
        pageContext.setAttribute("step1NumberOfActivitiesLabel", rb.getString("Edit_Step_1_NumberOfActivities_Label"));

        String pattern = rb.getString("Edit_Step_1_Instruction");
        pageContext.setAttribute("step1Instruction", MessageFormat.format(pattern, maxNumberOfActivities));
    %>

    <bbNG:form action="personalizationService" id="configForm" name="configForm" method="post">

        <div class="error">${messages.error}</div>

        <bbNG:dataCollection markUnsavedChanges="false" showSubmitButtons="true">
            <bbNG:step title="${step1Title}" instructions="${step1Instruction}">

                <bbNG:dataElement label="${step1NumberOfActivitiesLabel}">
                    <input type="number" name="numberOfActivities" value="<%= numberOfActivities %>" min="1"
                           max="<%= maxNumberOfActivities %>" />
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:stepSubmit showCancelButton="false"/>
        </bbNG:dataCollection>
    </bbNG:form>
</bbNG:modulePage>
