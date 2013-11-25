<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@page import="
        blackboard.data.navigation.NavigationItem,
        blackboard.persist.navigation.NavigationItemDbLoader,
        blackboard.platform.plugin.PlugInUtil,
        nl.eveoh.mytimetable.block.model.Configuration,java.util.Map"
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

        Configuration configuration = (Configuration) request.getAttribute("configuration");
        pageContext.setAttribute("configuration", configuration);

        if (messages == null) {
            // We were not called from the Servlet
            throw new ServletException("Page can only be called from the servlet.");
        }
    %>

    <bbNG:pageHeader
            instructions="Here you can edit the content of the various MyTimetable upcoming events building block configuration files.">
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

                <bbNG:dataElement label="Number of events to show" isRequired="true">
                    <input
                            type="text"
                            name="numberOfEvents"
                            value="${fn:escapeXml(configuration.numberOfEvents)}"
                            size="5" />

                    <div class="error">${messages.numberOfEvents}</div>
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:step title="Web service configuration" instructions="Configure the MyTimetable web service to be used by this building block.">

                <bbNG:dataElement label="MyTimetable API URL (one per line)" isRequired="true">
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

                <bbNG:dataElement label="Disable SSL certificate name verification">
                    <input
                            type="checkbox"
                            name="sslNameCheck"
                            value="disable" <c:if test="${!configuration.sslNameCheck}">checked="checked" </c:if>/>
                </bbNG:dataElement>
            </bbNG:step>

            <bbNG:step title="Domain configuration" instructions="Configure domain specific settings for the MyTimetable web service.">
                <bbNG:dataElement label="Domain prefix for Blackboard username" isRequired="false">
                    <input
                            type="text"
                            name="usernameDomainPrefix"
                            value="${fn:escapeXml(configuration.usernameDomainPrefix)}"
                            size="25" />

                    <div class="error">${messages.usernameDomainPrefix}</div>
                </bbNG:dataElement>
            </bbNG:step>

            <%--<bbNG:step title="Custom CSS (not working yet)"--%>
                       <%--instructions="Configure custom CSS which will be used by the building block.">--%>

                <%--<bbNG:dataElement label="Domain prefix for Blackboard username" isRequired="false">--%>
                    <%--<textarea--%>
                            <%--name="customCss"--%>
                            <%--value="${fn:escapeXml(configuration.customCss)}"--%>
                            <%--size="100"--%>
                            <%--rows="5"></textarea>--%>

                    <%--<div class="error">${messages.customCss}</div>--%>
                <%--</bbNG:dataElement>--%>
            <%--</bbNG:step>--%>

            <bbNG:stepSubmit showCancelButton="true" cancelUrl="<%= cancelUrl %>" />
        </bbNG:dataCollection>
    </bbNG:form>

</bbNG:genericPage>
