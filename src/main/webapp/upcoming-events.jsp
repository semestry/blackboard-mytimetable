<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="
    blackboard.data.user.User,
    nl.eveoh.mytimetable.blackboard.ConfigUtil,
    nl.eveoh.mytimetable.block.model.Configuration,
    nl.eveoh.mytimetable.block.model.Event,
    nl.eveoh.mytimetable.block.service.MyTimetableService,
    nl.eveoh.mytimetable.block.service.MyTimetableServiceImpl,
    org.slf4j.Logger,
    org.slf4j.LoggerFactory,
    java.io.PrintWriter,
    java.util.List
"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="/bbData" prefix="bbData" %>
<%@ taglib uri="/bbNG" prefix="bbNG"%>

<bbData:context id="ctx">

<%
    Logger log = LoggerFactory.getLogger("upcoming-events.jsp");

    // load Configuration
    Configuration configuration = ConfigUtil.loadConfig();
    pageContext.setAttribute("configuration", configuration);

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

        MyTimetableService service = new MyTimetableServiceImpl();

        try {
            upcomingEvents = service.getEvents(username, configuration);
        } catch (Exception e) {
            ex = e;
            log.error("Unable to fetch events.", e);
        }

        if (upcomingEvents == null) {
            connectionProblem = true;
        }
    } else {
        log.debug("User is nog logged in.");
    }

    pageContext.setAttribute("isLoggedIn", isLoggedIn);
    pageContext.setAttribute("connectionProblem", connectionProblem);
    pageContext.setAttribute("upcomingEvents", upcomingEvents);
%>

<%@ include file="upcoming-events-css.jsp" %>
<style>
<%= configuration.getCustomCss() %>
</style>

<fmt:setLocale value="${ctx.locale}" />
<fmt:setBundle basename="BlackboardMessagesBundle" />

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
                        <td class="eveoh-mytimetable-date">
                            <fmt:formatDate pattern="dd-MM" value="${event.startDate}" />
                        </td>
                        <td class="eveoh-mytimetable-time">
                            <fmt:formatDate pattern="HH:mm" value="${event.startDate}" /> - <fmt:formatDate pattern="HH:mm" value="${event.endDate}" />
                        </td>
                        <td class="eveoh-mytimetable-location">
                            <c:choose>
                                <c:when test="${empty event.locations}">
                                    <fmt:message key="UnknownLocation" />
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