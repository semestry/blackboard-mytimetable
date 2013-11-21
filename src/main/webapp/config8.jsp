<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page
	import="blackboard.platform.intl.LocaleManagerFactory,blackboard.platform.intl.BbLocale,blackboard.platform.intl.BundleManagerFactory,blackboard.platform.intl.BbResourceBundle,blackboard.persist.navigation.NavigationItemDbLoader,blackboard.data.navigation.NavigationItem,blackboard.platform.plugin.PlugInUtil,blackboard.data.user.User,java.util.ResourceBundle,java.util.Map,java.util.Properties"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="/bbUI" prefix="bbUI"%>

<bbUI:docTemplate title="MyTimetable upcoming activities settings">

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
	Map<String, String> targets = (Map<String, String>) request.getAttribute("targets");
	Properties configuration = (Properties) request.getAttribute("configuration");
	
	if(messages == null){
	    // We were not called from the Servlet
	    throw new ServletException("Page can only be called from the servlet.");
	}
%>

	<bbUI:breadcrumbBar environment="SYS_ADMIN" handle="admin_plugin_manage">
		<bbUI:breadcrumb>MyTimetable upcoming activities settings</bbUI:breadcrumb>
	</bbUI:breadcrumbBar>

	<bbUI:titleBar iconUrl="/images/ci/icons/tools_u.gif">
		MyTimetable upcoming activities settings
	</bbUI:titleBar>

	<form action="<%=formAction %>" method="POST" id="configForm" name="configForm">
		
		<div class="error">${messages.error}</div>

			<bbUI:step title="Application configuration">
				<bbUI:dataElement label="MyTimetable URL" required="true">
					<input type="text" name="mytimetable_full_url"
						value="${fn:escapeXml(configuration.mytimetable_full_url)}"
						size="100" />
					<div class="error">${messages.mytimetable_full_url}</div>
				</bbUI:dataElement>

				<bbUI:dataElement label="MyTimetable target" required="true">
					<select name="mytimetable_target">
						<c:forEach items="${targets}" var="target">
							<option value="${target.key}" ${target.key == configuration.mytimetable_target ? 'selected="selected"' : ''}>${target.value}</option>
						</c:forEach>
					</select>
					<div class="error">${messages.mytimetable_target}</div>
				</bbUI:dataElement>
				
				<bbUI:dataElement label="Number of activities to show" required="true">
					<input type="text" name="number_of_activities"
						value="${fn:escapeXml(configuration.number_of_activities)}"
						size="25" />
					<div class="error">${messages.number_of_activities}</div>
				</bbUI:dataElement>
			</bbUI:step>
			
			<bbUI:step title="Web service configuration">
				<bbUI:dataElement label="MyTimetable web service URL (separate multiple URLs with spaces)" required="true">
					<input type="text" name="mytimetable_web_service_url"
						value="${fn:escapeXml(configuration.mytimetable_web_service_url)}"
						size="100" />
					<div class="error">${messages.mytimetable_web_service_url}</div>
				</bbUI:dataElement>

				<bbUI:dataElement label="MyTimetable web service shared secret" required="true">
					<input type="text" name="mytimetable_web_service_shared_secret"
						value="${fn:escapeXml(configuration.mytimetable_web_service_shared_secret)}"
						size="100" />
					<div class="error">${messages.mytimetable_web_service_shared_secret}</div>
				</bbUI:dataElement>
			</bbUI:step>
			
			<bbUI:step title="Domain configuration">
				<bbUI:dataElement label="Domain prefix for Blackboard username" required="false">
					<input type="text" name="mytimetable_domain_prefix"
						value="${fn:escapeXml(configuration.mytimetable_domain_prefix)}"
						size="25" />
					<div class="error">${messages.mytimetable_domain_prefix}</div>
				</bbUI:dataElement>
			</bbUI:step>
			
			<bbUI:stepSubmit title="Submit" />
	</form>

</bbUI:docTemplate>
