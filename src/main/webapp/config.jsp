<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@page import="
        blackboard.data.navigation.NavigationItem,
        blackboard.persist.navigation.NavigationItemDbLoader,
        blackboard.platform.plugin.PlugInUtil,
        nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration,
        java.util.Map"
%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="/bbNG" prefix="bbNG" %>

<bbNG:genericPage entitlement="system.admin.VIEW" ctxId="ctx">

    <style type="text/css">
        .error {
            color: red;
        }
    </style>

    <%
        // add some form of authentication check
        PlugInUtil.authorizeForSystemAdmin(request, response);

        // generate a final cancelUrl
        NavigationItemDbLoader niLoader = NavigationItemDbLoader.Default.getInstance();
        NavigationItem navItem = niLoader.loadByInternalHandle("admin_plugin_manage");
        String cancelUrl = navItem.getHref();
        String formAction = "configService";

        Map<String, String> messages = (Map<String, String>) request.getAttribute("messages");
        pageContext.setAttribute("messages", messages);

        Map<String, String> targets = (Map<String, String>) request.getAttribute("targets");
        pageContext.setAttribute("targets", targets);

        WidgetConfiguration configuration = (WidgetConfiguration) request.getAttribute("configuration");
        pageContext.setAttribute("configuration", configuration);
        pageContext.setAttribute("timetableTypesArray", configuration.getTimetableTypes().toArray(new String[0]));

        if (messages == null) {
            // We were not called from the Servlet
            throw new ServletException("Page can only be called from the servlet.");
        }
    %>

    <bbNG:pageHeader instructions="Here you can edit the content of the various MyTimetable upcoming events building block configuration files.">
        <bbNG:breadcrumbBar environment="SYS_ADMIN_PANEL" navItem="admin_plugin_manage">
            <bbNG:breadcrumb>MyTimetable Upcoming Events - Settings</bbNG:breadcrumb>
        </bbNG:breadcrumbBar>
        <bbNG:pageTitleBar iconUrl="/images/ci/icons/tools_u.gif" showTitleBar="true" title="MyTimetable Upcoming Events  - Settings"/>
    </bbNG:pageHeader>

    <bbNG:form action="<%= formAction %>" id="configForm" name="configForm" method="post">

        <div class="error">${messages.error}</div>

        <bbNG:dataCollection markUnsavedChanges="false" showSubmitButtons="true">
            <bbNG:step title="Application configuration" instructions="Configure the full URL of MyTimetable and the number of events to be shown.">

                <bbNG:dataElement label="MyTimetable URL" isRequired="true">
                    <input
                            type="text"
                            name="applicationUri"
                            value="${fn:escapeXml(configuration.applicationUri)}"
                            size="100" />

                    <div class="error">${messages.applicationUri}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="MyTimetable link target" isRequired="true">
                    <select name="applicationTarget">
                        <c:forEach items="${targets}" var="target">
                            <option value="${target.key}" ${target.key == configuration.applicationTarget ? 'selected="selected"' : ''}>${target.value}</option>
                        </c:forEach>
                    </select>

                    <div class="error">${messages.applicationTarget}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="Maximum number of events to show" isRequired="true">
                    <input
                            type="text"
                            name="numberOfEvents"
                            value="${fn:escapeXml(configuration.maxNumberOfEvents)}"
                            size="5" />

                    <div class="error">${messages.numberOfEvents}</div>
                </bbNG:dataElement>
                <bbNG:dataElement label="Default number of events to show" isRequired="true">
                    <input
                            type="text"
                            name="defaultNumberOfEvents"
                            value="${fn:escapeXml(configuration.defaultNumberOfEvents)}"
                            size="5" />

                    <div class="error">${messages.numberOfEvents}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="Include activity type in overview" isRequired="true">
                    <input
                            type="checkbox"
                            name="showActivityType"
                            value="enable"  <c:if test="${configuration.showActivityType}">checked="checked" </c:if>/>
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:step title="API connection configuration" instructions="Configure the MyTimetable web service to be used by this building block.">

                <bbNG:dataElement label="MyTimetable API URL (one per line, ending with '/api/v0/')" isRequired="true">
                    <textarea
                            name="apiEndpointUris"
                            cols="80"
                            rows="5"><c:forEach items="${configuration.apiEndpointUris}" var="uri"><c:out value="${uri}" />&#10;</c:forEach></textarea>
                    <div class="error">${messages.apiEndpointUris}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="MyTimetable API key" isRequired="true">
                    <input
                            type="text"
                            name="apiKey"
                            value="${fn:escapeXml(configuration.apiKey)}"
                            size="100" />

                    <div class="error">${messages.apiKey}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="Timetable types to display (semi-colon separated)">
                    <input
                            type="text"
                            name="timetableTypes"
                            value="${fn:escapeXml(fn:join(timetableTypesArray,";"))}"
                            size="100" />
                </bbNG:dataElement>

                <bbNG:dataElement label="Disable SSL certificate CN verification">
                    <input
                            type="checkbox"
                            name="apiSslCnCheck"
                            value="disable" <c:if test="${!configuration.apiSslCnCheck}">checked="checked" </c:if>/>
                </bbNG:dataElement>

                <bbNG:dataElement label="Timeout for connecting to an API endpoint" isRequired="true">
                    <input
                            type="text"
                            name="apiConnectTimeout"
                            value="${fn:escapeXml(configuration.apiConnectTimeout)}"
                            size="5" />

                    <div class="error">${messages.apiConnectTimeout}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="Timeout of socket waiting for data" isRequired="true">
                    <input
                            type="text"
                            name="apiSocketTimeout"
                            value="${fn:escapeXml(configuration.apiSocketTimeout)}"
                            size="5" />

                    <div class="error">${messages.apiSocketTimeout}</div>
                </bbNG:dataElement>

                <bbNG:dataElement label="Maximum number of concurrent API connections" isRequired="true">
                    <input
                            type="text"
                            name="apiMaxConnections"
                            value="${fn:escapeXml(configuration.apiMaxConnections)}"
                            size="5" />

                    <div class="error">${messages.apiMaxConnections}</div>
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:step title="Domain configuration" instructions="Configure domain specific settings for the MyTimetable API.">
                <bbNG:dataElement label="Domain prefix for Blackboard username (excluding slash)" isRequired="false">
                    <input
                            type="text"
                            name="usernameDomainPrefix"
                            value="${fn:escapeXml(configuration.usernameDomainPrefix)}"
                            size="100" />
                </bbNG:dataElement>

                <bbNG:dataElement label="Postfix for Blackboard username" isRequired="false">
                    <input
                            type="text"
                            name="usernamePostfix"
                            value="${fn:escapeXml(configuration.usernamePostfix)}"
                            size="100" />
                </bbNG:dataElement>

            </bbNG:step>

            <bbNG:step title="Customization"
                       instructions="Customize the appearance of the building block.">

                <bbNG:dataElement label="Override CSS" isRequired="false">
                    <textarea
                            name="customCss"
                            value="${fn:escapeXml(configuration.customCss)}"
                            cols="80"
                            rows="15">${fn:escapeXml(configuration.customCss)}</textarea>
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:stepSubmit showCancelButton="true" cancelUrl="<%= cancelUrl %>" />
        </bbNG:dataCollection>
    </bbNG:form>

</bbNG:genericPage>
