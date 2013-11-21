<%@page	contentType="text/html; charset=UTF-8"%>
<%@page import="
    java.io.PrintWriter,
	java.util.Arrays,
	java.util.Collections,
	java.text.SimpleDateFormat,
	java.util.List,
	java.util.Iterator,
	java.util.ResourceBundle,
	nl.eveoh.scheduleviewer.client.calendar.CalendarItem,
	nl.eveoh.scheduleviewer.services.UserCalendarItemsService,
	java.util.Locale,
	java.util.ArrayList,
	blackboard.platform.intl.LocaleManagerFactory,
	java.util.Properties,
	nl.eveoh.mytimetable.buildingblock.ConfigUtil,
	org.apache.cxf.aegis.databinding.AegisDatabinding,
	org.apache.cxf.jaxws.JaxWsProxyFactoryBean,
	org.apache.cxf.transports.http.configuration.HTTPClientPolicy,
	org.apache.cxf.transport.http.HTTPConduit,
	org.apache.cxf.frontend.ClientProxy,
	org.apache.cxf.endpoint.Client,
	org.apache.cxf.configuration.jsse.TLSClientParameters,
	javax.xml.ws.soap.SOAPFaultException,
	blackboard.data.user.User,
	org.slf4j.Logger,
	org.slf4j.LoggerFactory
"%>

<%@taglib uri="/bbData" prefix="bbData"%>
<bbData:context id="ctx">

<%
Logger log = LoggerFactory.getLogger(getClass());

// date and time formatters
SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MM-yyyy");
SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");

// error messages
List<String> errorMessages = new ArrayList<String>();

//load locale and resource bundle
Locale locale = LocaleManagerFactory.getInstance().getLocale().getLocaleObject();

String localeString = "";
if (!locale.getLanguage().isEmpty() && !locale.getCountry().isEmpty()) {
    localeString = locale.getLanguage() + "_" + locale.getCountry();
} else if (!locale.getLanguage().isEmpty()) {
    localeString = locale.getLanguage();
}

// load ResouceBundle
ResourceBundle messages = ResourceBundle.getBundle("BlackboardMessagesBundle", locale);
       
// get current username
String username = null;
boolean isLoggedIn = false;

if (ctx.hasUserContext()) {
    User user = ctx.getUser();
    username = user.getUserName();
    User.SystemRole role = user.getSystemRole();
    isLoggedIn = role != User.SystemRole.GUEST;
}

// load configuration
Properties configuration = ConfigUtil.loadConfig();
List<CalendarItem> upcomingActivities = null;
Exception ex = null;

if (isLoggedIn) {
    log.debug("Logged in. Fetching upcoming activities");
    String secret = configuration.getProperty("mytimetable_web_service_shared_secret");
    
    // prefix the username, for example when MyTimetable is used in a domain
    String domainPrefix = configuration.getProperty("mytimetable_domain_prefix");    
    if (domainPrefix != null && !domainPrefix.isEmpty()) {
        username = domainPrefix + "\\" + username;
    }
    
    int numberOfActivities = Integer.parseInt(configuration.getProperty("number_of_activities"));
    
    List<String> urls = Arrays.asList(configuration.getProperty("mytimetable_web_service_url").split(" "));
    Collections.shuffle(urls);
    
    int i = 0;
    
	do{
	    // load upcoming activities from webservice
	    try {
		    JaxWsProxyFactoryBean clientFactory = new JaxWsProxyFactoryBean();
		    clientFactory.setServiceClass(UserCalendarItemsService.class);
		    clientFactory.setAddress(urls.get(i));
		    clientFactory.getServiceFactory().setDataBinding(new AegisDatabinding());
		    
		    UserCalendarItemsService calendarItemsService = (UserCalendarItemsService) clientFactory.create();
		    
		    // Set timeout
		    Client client = ClientProxy.getClient(calendarItemsService);
  			HTTPConduit http = (HTTPConduit) client.getConduit(); 
  		    HTTPClientPolicy httpClientPolicy = new HTTPClientPolicy();
  		    httpClientPolicy.setConnectionTimeout(3000);
  		    httpClientPolicy.setAllowChunking(false);
  		    httpClientPolicy.setReceiveTimeout(3000); 
  		    http.setClient(httpClientPolicy);
		    TLSClientParameters param = new TLSClientParameters(); 
			param.setDisableCNCheck(true); 
			http.setTlsClientParameters(param); 

		    upcomingActivities = calendarItemsService.getUserCalendarItems(secret, username, numberOfActivities, localeString);
	    }
	    catch (Exception ex2) {
            ex = ex2;
	        log.debug("Could not connect to webservice url: " + urls.get(i), ex);
	    }
	} while (upcomingActivities == null && ++i < urls.size());
    
    if(upcomingActivities == null){
        errorMessages.add(messages.getString("UpcomingActivities_could_not_connect_to_ws"));
    }
}
else {
    log.debug("User is nog logged in.");
    errorMessages.add(messages.getString("UpcomingActivities_notLoggedIn"));
}

String mytimetableFullUrl = configuration.getProperty("mytimetable_full_url");
String mytimetableTarget = configuration.getProperty("mytimetable_target");
%>

<script type="text/javascript">
function tooltip_show(tooltipId, linkId)
{
	tooltip = document.getElementById(tooltipId);
	    
	link = document.getElementById(linkId); 
	
	if (link.offsetParent) { 
		x = link.offsetLeft;
		y = link.offsetTop;
	}
	else {
		x = link.x;
		y = link.y;
	}
	
	x += 0;
	y += 20;
	    
	tooltip.style.top = y + 'px';
	tooltip.style.left = x + 'px';
	
	tooltip.style.visibility = 'visible'; 
}

function tooltip_hide(tooltipId)
{
	tooltip = document.getElementById(tooltipId); 
	tooltip.style.visibility = 'hidden';
}  
</script>

<style type="text/css">
#container {
	width: 100%;
}

table.eveoh-upcoming-activities {
	width: 100%;
	margin-bottom: 5px;
	table-layout: fixed;
	white-space: nowrap;
}

table.eveoh-upcoming-activities tr td
	{
	padding: 3px;
	border-bottom: 1px dotted #eee;
}

table.eveoh-upcoming-activities th
	{
	padding: 3px;
}

table.eveoh-upcoming-activities th {
	color: #EC2D9B;
	font-weight: bold;
	overflow: hidden;
	text-overflow: ellipsis;
	-o-text-overflow: ellipsis;
	-ms-text-overflow: ellipsis; 
	-moz-binding: url('xml/ff_ellipsis.xml#ellipsis'); /* Fix for FF 3.x, fixed in FF7 (https://bugzilla.mozilla.org/show_bug.cgi?id=312156) */
}

table.eveoh-upcoming-activities tr th.header-activity {
	
}

table.eveoh-upcoming-activities tr th.header-date {
	width: 80px;
	min-width: 80px;
}

table.eveoh-upcoming-activities tr th.header-time {
	width: 90px;
	min-width: 90px;
}

table.eveoh-upcoming-activities tr th.header-location {
	width: 120px;
	min-width: 120px;
}

table.eveoh-upcoming-activities tr td.activity ul li {
	list-style: square outside none;
	margin-left: 18px;
	float: left;
}

table.eveoh-upcoming-activities tr td.act-other ul li {
	color: #000;
}

table.eveoh-upcoming-activities tr td.act-class ul li {
	color: #EC2D9B;
}

table.eveoh-upcoming-activities tr td.activity span {
	color: #222;
	overflow: hidden;
	text-overflow: ellipsis;
	-o-text-overflow: ellipsis;
	-ms-text-overflow: ellipsis; 
	-moz-binding: url('xml/ff_ellipsis.xml#ellipsis'); /* Fix for FF 3.x, fixed in FF7 (https://bugzilla.mozilla.org/show_bug.cgi?id=312156) */
	display: block;
	padding-bottom: 1px;
}

#full-schedule {
	float: right;
}

#full-schedule ul {
	list-style: square outside none;
	color: #0076A1;
}

.all-items {
	visibility: hidden;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 1000;
	overflow: hidden;
	background: white;
	border: 1px solid #EC2D9B;
	padding: 5px 9px;
}

.multiple-locations {
	border-bottom: .1em dotted;
	position: relative;
}

p.error {
	font-weight: bold;
	padding-bottom: 5px;
}

ul.error li {
	list-style: square outside none;
	margin-left: 18px;
}
</style>

<div id="container">
	<% if (!errorMessages.isEmpty()) { %>
	<p class="error"><%=messages.getString("UpcomingActivities_errorHeader") %></p>
		<ul class="error">
		<%
		for (String s : errorMessages) {
		    out.print("<li>" + s + "</li>");
		}
		%>
		</ul>	
	<% } else if (upcomingActivities == null || upcomingActivities.isEmpty()) { %>
		<p class="empty-timetable"><%=messages.getString("UpcomingActivities_emptyTimetable") %></p>
	<% } else { %>

	<table class="eveoh-upcoming-activities" cellpadding="0"
		cellspacing="0">
		<thead>
			<tr>
				<th class="header-activity"><%=messages.getString("UpcomingActivities_header_activity") %></th>
				<th class="header-date"><%=messages.getString("UpcomingActivities_header_date") %></th>
				<th class="header-time"><%=messages.getString("UpcomingActivities_header_time") %></th>
				<th class="header-location"><%=messages.getString("UpcomingActivities_header_location") %></th>
			</tr>
		</thead>
		<tbody>
		<%
		int num = 0;
		
		for (CalendarItem ci : upcomingActivities) {
		%>
			<tr>
				<td class="activity">
					<ul>
						<li></li>
					</ul>
					<span><%= ci.getActivityDescription() %></span></td>
				<td class="date"><%=dateFormatter.format(ci.getStartDate())%></td>
				<td class="time"><%=timeFormatter.format(ci.getStartDate())%> - <%=timeFormatter.format(ci.getEndDate())%></td>
				<td class="location">
				<%
				 	if (ci.getLocation().isEmpty()) {
						out.print(messages.getString("UpcomingActivities_unknownLocation"));
                    } else if (ci.getLocation().size() == 1) {
						out.print(ci.getLocation().iterator().next().toString());
                    } else {
                 %>
                 	<span id="link<%=num%>" class="multiple-locations" onmouseover="tooltip_show('loctip<%=num%>', 'link<%=num%>');"
					onmouseout="tooltip_hide('loctip<%=num%>');"><%= messages.getString("UpcomingActivities_multipleLocations") %></span>
                 	<div id="loctip<%=num%>" class="all-items">
						<ul>
						<%
						for (String l : ci.getLocation()) {
						    out.print("<li>" + l.toString() + "</li>");
						}
						%>
						</ul>
					</div>
				<% } // end else %>
				</td>
			</tr>
		<% 
			num++; 
		} // end for 
		%>
		</tbody>
	</table>

	<% } %>

	<div id="full-schedule">
		<ul>
			<li>
				<a href="<%= mytimetableFullUrl %>" target="<%= mytimetableTarget %>"><%=messages.getString("UpcomingActivities_fullSchedule_link_title") %></a>
			</li>
		</ul>
	</div>
</div>
<!-- 
<% if (ex != null) {
    out.print(ex.toString());
    ex.printStackTrace(new PrintWriter(out, true));
} %>
 -->
</bbData:context>