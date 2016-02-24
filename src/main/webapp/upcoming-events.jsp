<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="
    blackboard.data.user.User,
    blackboard.portal.external.CustomData,
    nl.eveoh.mytimetable.apiclient.configuration.WidgetConfiguration,
    nl.eveoh.mytimetable.apiclient.model.Event,
    nl.eveoh.mytimetable.apiclient.service.MyTimetableServiceImpl,
    nl.eveoh.mytimetable.blackboard.MyTimetableServiceContainer,
    org.slf4j.Logger,
    org.slf4j.LoggerFactory,
    java.io.PrintWriter
"%>
<%@ page import="java.util.List" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="/bbData" prefix="bbData" %>

<bbData:context id="ctx">

<%
    Logger log = LoggerFactory.getLogger("upcoming-events.jsp");

    MyTimetableServiceImpl service = MyTimetableServiceContainer.getService();

    WidgetConfiguration configuration = (WidgetConfiguration) service.getConfiguration();
    pageContext.setAttribute("configuration", configuration);

    CustomData cd = CustomData.getModulePersonalizationData(pageContext);

    int numberOfActivities;

    if (cd.getValue("numberOfActivities") == null) {
        numberOfActivities = configuration.getDefaultNumberOfEvents();
    } else {
        numberOfActivities = Math.min(Integer.parseInt(cd.getValue("numberOfActivities")),
                configuration.getMaxNumberOfEvents());
    }

    // get current username
    String username = null;
    boolean isLoggedIn = false;

    if (ctx.hasUserContext()) {
        User user = ctx.getUser();
        username = user.getUserName();
        User.SystemRole role = user.getSystemRole();
        isLoggedIn = role != User.SystemRole.GUEST;
    }

    List<Event> upcomingEvents = null;
    Exception ex = null;

    boolean connectionProblem = false;
    if (isLoggedIn) {
        log.debug("Logged in. Fetching upcoming events");

        try {
            upcomingEvents = service.getUpcomingEvents(username);
            upcomingEvents = upcomingEvents.subList(0, Math.min(numberOfActivities, upcomingEvents.size()));
        } catch (Exception e) {
            ex = e;
            log.error("Unable to fetch events.", e);
        }

        if (upcomingEvents == null) {
            connectionProblem = true;
        }
    } else {
        log.debug("User is not logged in.");
    }

    pageContext.setAttribute("isLoggedIn", isLoggedIn);
    pageContext.setAttribute("connectionProblem", connectionProblem);
    pageContext.setAttribute("upcomingEvents", upcomingEvents);
%>

<fmt:setLocale value="${ctx.locale}" />
<fmt:setBundle basename="BlackboardMessagesBundle" />

<%-- Start the page with a Scoped element. --%>
<%-- The element cannot be empty, otherwise it will be removed as well. --%>
<%-- https://github.com/eveoh/blackboard-mytimetable/issues/8 --%>
<span class="eveoh-mytimetable-hidden">&nbsp;</span>

<%@ include file="upcoming-events-css.jsp" %>

<c:if test="${not empty configuration.customCss}">
<style>
    <c:out escapeXml="false" value="${configuration.customCss}" />
</style>
</c:if>

<div id="eveoh-mytimetable-container">
    <c:choose>
        <c:when test="${!isLoggedIn}">
            <p class="eveoh-mytimetable-error-header">
                <fmt:message key="Error_Header" />
            </p>
            <p class="eveoh-mytimetable-error">
                <fmt:message key="Error_UserNotLoggedIn" />
            </p>
        </c:when>
        <c:when test="${connectionProblem}">
            <p class="eveoh-mytimetable-error-header">
                <fmt:message key="Error_Header" />
            </p>
            <p class="eveoh-mytimetable-error">
                <fmt:message key="Error_CouldNotConnectToWebService" />
            </p>
        </c:when>
        <c:when test="${empty upcomingEvents}">
            <p class="eveoh-mytimetable-empty-timetable">
                <fmt:message key="EmptyTimetable" />
            </p>
        </c:when>
        <c:otherwise>
            <table class="eveoh-mytimetable-upcoming-events" cellpadding="0" cellspacing="0">
                <thead>
                <tr>
                    <th class="eveoh-mytimetable-event">
                        <fmt:message key="Header_Description" />
                    </th>
                    <c:if test="${configuration.showActivityType}">
                        <th class="eveoh-mytimetable-type">
                            <fmt:message key="Header_ActivityType" />
                        </th>
                    </c:if>
                    <th class="eveoh-mytimetable-date">
                        <fmt:message key="Header_Date" />
                    </th>
                    <th class="eveoh-mytimetable-time">
                        <fmt:message key="Header_Time" />
                    </th>
                    <th class="eveoh-mytimetable-location">
                        <fmt:message key="Header_Location" />
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${upcomingEvents}" var="event">
                    <tr>
                        <td class="eveoh-mytimetable-event">
                            <span><c:out value="${event.activityDescription}" /></span></td>
                        <c:if test="${configuration.showActivityType}">
                            <td class="eveoh-mytimetable-type">
                                <span><c:out value="${event.activityType}" /></span></td>
                        </c:if>
                        <td class="eveoh-mytimetable-date">
                            <fmt:formatDate pattern="dd-MM" value="${event.startDate}" />
                        </td>
                        <td class="eveoh-mytimetable-time">
                            <fmt:formatDate pattern="HH:mm" value="${event.startDate}" /> - <fmt:formatDate pattern="HH:mm" value="${event.endDate}" />
                        </td>
                        <td class="eveoh-mytimetable-location">
                            <c:choose>
                                <c:when test="${empty event.locations}">
                                    <c:choose>
                                        <c:when test="${empty configuration.unknownLocationDescription}">
                                            <fmt:message key="UnknownLocation"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${configuration.unknownLocationDescription}">Unknown Location</c:out>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span title="<c:forEach items="${event.locations}" var="l" varStatus="status"><c:if test="${status.index > 0}">&#13;</c:if><c:out value="${l.name}" /></c:forEach>">
                                        <c:forEach items="${event.locations}" var="l" varStatus="status"><c:if test="${status.index > 0}">, </c:if><c:out value="${l.name}" /></c:forEach>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <div id="eveoh-mytimetable-application" class="moduleControlWrapper u_reverseAlign">
        <a class="button-6" href="<c:url value="${configuration.applicationUri}" />" target="<c:out value="${configuration.applicationTarget}" />">
            <fmt:message key="GoToTimetableApplication" />
        </a>
    </div>
</div>
<!--
<% if (ex != null) {
    out.print(ex.toString());
    ex.printStackTrace(new PrintWriter(out, true));
} %>
-->
</bbData:context>