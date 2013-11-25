/*
 * Eveoh MyTimetable, Web interface for timetables.
 *
 * Copyright (c) 2010 - 2013 Eveoh
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, see src/main/webapp/license/gpl-3.0.txt.
 * If not, see <http://www.gnu.org/licenses/>.
 */

package nl.eveoh.mytimetable.block.service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import nl.eveoh.mytimetable.block.exception.LocalizableException;
import nl.eveoh.mytimetable.block.model.Configuration;
import nl.eveoh.mytimetable.block.model.Event;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Implementation of the MyTimetableService interface.
 *
 * @see MyTimetableService
 * @author Marco Krikke
 */
public class MyTimetableServiceImpl implements MyTimetableService {

    private static final Logger log = Logger.getLogger(MyTimetableServiceImpl.class);

    private ObjectMapper mapper = new ObjectMapper();

    private HttpClient client;



    public MyTimetableServiceImpl() {
        // Make sure the Jackson ObjectMapper does not fail on other properties in the JSON response.
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

        HttpClientBuilder builder = HttpClientBuilder.create();
        this.client = builder.build();
    }

    /**
     * {@inheritDoc}
     */
    public List<Event> getEvents(String userId, Configuration configuration) {
        ArrayList<HttpUriRequest> requests = getApiRequests(userId, configuration);

        for (HttpUriRequest request : requests) {
            try {
                HttpResponse response = client.execute(request);

                return mapper.readValue(response.getEntity().getContent(),
                        mapper.getTypeFactory().constructCollectionType(List.class, Event.class));
            } catch (JsonParseException e) {
                log.error("Could not fetch results from MyTimetable API.", e);
            } catch (JsonMappingException e) {
                log.error("Could not fetch results from MyTimetable API.", e);
            } catch (ClientProtocolException e) {
                log.error("Could not fetch results from MyTimetable API.", e);
            } catch (IOException e) {
                log.error("Could not fetch results from MyTimetable API.", e);
            }
        }

        return null;
    }

    private ArrayList<HttpUriRequest> getApiRequests(String userId, Configuration configuration) {
        if (StringUtils.isBlank(userId)) {
            log.error("Username cannot be empty.");
            throw new LocalizableException("Username cannot be empty.", "notLoggedIn");
        }

        if (StringUtils.isBlank(configuration.getApiKey())) {
            log.error("API key cannot be empty.");
            throw new LocalizableException("API key cannot be empty.");
        }

        // Prefix the username, for example when MyTimetable is used in a domain.
        String domainPrefix = configuration.getUsernameDomainPrefix();
        if (domainPrefix != null && !domainPrefix.isEmpty()) {
            userId = domainPrefix + '\\' + userId;
        }

        // build request URI
        Date currentTime = new Date();

        ArrayList<HttpUriRequest> requests = new ArrayList<HttpUriRequest>();

        for (String uri : configuration.getApiEndpointUris()) {
            String baseUrl;

            if (uri.endsWith("/")) {
                baseUrl = uri + "timetable";
            } else {
                baseUrl = uri + "/timetable";
            }

            try {
                URIBuilder uriBuilder = new URIBuilder(baseUrl);
                uriBuilder.addParameter("startDate", Long.toString(currentTime.getTime()));
                uriBuilder.addParameter("limit", Integer.toString(configuration.getNumberOfEvents()));

                URI apiUri = uriBuilder.build();

                HttpUriRequest request = new HttpGet(apiUri);
                request.addHeader("apiToken", configuration.getApiKey());
                request.addHeader("requestedAuth", userId);

                requests.add(request);
            } catch (URISyntaxException e) {
                log.error("Incorrect MyTimetable API url syntax.", e);
            }
        }

        if (requests.isEmpty()) {
            log.error("No usable MyTimetable API url.");
            throw new LocalizableException("No usable MyTimetable API url.");
        }

        return requests;
    }
}