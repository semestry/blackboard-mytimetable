/*
 * Copyright 2013 - 2014 Eveoh
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package nl.eveoh.mytimetable.blackboard;

import ch.qos.logback.classic.LoggerContext;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Shuts down logback properly and shuts down API client.
 */
public class ShutdownListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Stop Logback
        LoggerContext loggerContext = (LoggerContext) LoggerFactory.getILoggerFactory();
        loggerContext.stop();

        // Stop MyTimetable API client
        MyTimetableServiceContainer.getService().close();
    }
}
