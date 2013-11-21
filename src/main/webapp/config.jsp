<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<%@page import="org.apache.commons.lang3.StringEscapeUtils"%>
<%@page
	import="blackboard.platform.intl.LocaleManagerFactory,blackboard.platform.intl.BbLocale,blackboard.platform.intl.BundleManagerFactory,blackboard.platform.intl.BbResourceBundle,blackboard.persist.navigation.NavigationItemDbLoader,blackboard.data.navigation.NavigationItem,blackboard.platform.plugin.PlugInUtil,blackboard.data.user.User,java.util.ResourceBundle,java.util.Map,java.util.Properties"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="/bbNG" prefix="bbNG"%>

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
	Map<String, String> targets = (Map<String, String>) request.getAttribute("targets");
	Properties configuration = (Properties) request.getAttribute("configuration");
	
	if(messages == null){
	    // We were not called from the Servlet
	    throw new ServletException("Page can only be called from the servlet.");
	}
%>

	<bbNG:pageHeader
		instructions="Here you can edit the content of the various MyTimetable upcoming activities building block configuration files.">
		<bbNG:breadcrumbBar environment="SYS_ADMIN_PANEL"
			navItem="admin_plugin_manage">
			<bbNG:breadcrumb>MyTimetable upcoming activities settings</bbNG:breadcrumb>
		</bbNG:breadcrumbBar>
		<bbNG:pageTitleBar iconUrl="/images/ci/icons/tools_u.gif"
			showTitleBar="true" title="MyTimetable upcoming activities settings" />
	</bbNG:pageHeader>

	<bbNG:form action="<%=formAction%>" id="configForm" name="configForm"
		method="post">
		
		<div class="error">${messages.error}</div>

		<bbNG:dataCollection markUnsavedChanges="false"
			showSubmitButtons="true">
			<bbNG:step title="Application configuration"
				instructions="Configure the full URL of MyTimetable and the number of activities to be shown.">

				<bbNG:dataElement label="MyTimetable URL" isRequired="true">
					<input type="text" name="mytimetable_full_url"
						value="${fn:escapeXml(configuration.mytimetable_full_url)}"
						size="100" />
					<div class="error">${messages.mytimetable_full_url}</div>
				</bbNG:dataElement>

				<bbNG:dataElement label="MyTimetable target" isRequired="true">
					<select name="mytimetable_target">
						<c:forEach items="${targets}" var="target">
							<option value="${target.key}" ${target.key == configuration.mytimetable_target ? 'selected="selected"' : ''}>${target.value}</option>
						</c:forEach>
					</select>
					<div class="error">${messages.mytimetable_target}</div>
				</bbNG:dataElement>
				
				<bbNG:dataElement label="Number of activities to show" isRequired="true">
					<input type="text" name="number_of_activities"
						value="${fn:escapeXml(configuration.number_of_activities)}"
						size="25" />
					<div class="error">${messages.number_of_activities}</div>
				</bbNG:dataElement>
			</bbNG:step>
			
			<bbNG:step title="Web service configuration"
				instructions="Configure the MyTimetable web service to be used by this building block.">

				<bbNG:dataElement label="MyTimetable web service URL (separate multiple URLs with spaces)" isRequired="true">
					<input type="text" name="mytimetable_web_service_url"
						value="${fn:escapeXml(configuration.mytimetable_web_service_url)}"
						size="100" />
					<div class="error">${messages.mytimetable_web_service_url}</div>
				</bbNG:dataElement>

				<bbNG:dataElement label="MyTimetable web service shared secret" isRequired="true">
					<input type="text" name="mytimetable_web_service_shared_secret"
						value="${fn:escapeXml(configuration.mytimetable_web_service_shared_secret)}"
						size="100" />
					<div class="error">${messages.mytimetable_web_service_shared_secret}</div>
				</bbNG:dataElement>
			</bbNG:step>
			
			<bbNG:step title="Domain configuration"
				instructions="Configure domain specific settings for the MyTimetable web service.">

				<bbNG:dataElement label="Domain prefix for Blackboard username" isRequired="false">
					<input type="text" name="mytimetable_domain_prefix"
						value="${fn:escapeXml(configuration.mytimetable_domain_prefix)}"
						size="25" />
					<div class="error">${messages.mytimetable_domain_prefix}</div>
				</bbNG:dataElement>
			</bbNG:step>
			
			<bbNG:stepSubmit showCancelButton="true" cancelUrl="<%=cancelUrl%>" />
		</bbNG:dataCollection>
	</bbNG:form>

</bbNG:genericPage>
