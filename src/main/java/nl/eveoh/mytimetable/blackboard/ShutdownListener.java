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
