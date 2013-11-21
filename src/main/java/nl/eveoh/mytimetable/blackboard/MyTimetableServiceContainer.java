package nl.eveoh.mytimetable.blackboard;

import nl.eveoh.mytimetable.apiclient.service.MyTimetableServiceImpl;

/**
 * Container for the MyTimetableService instance, so it can be shared between requests.
 *
 * @author Erik van Paassen
 */
public class MyTimetableServiceContainer {

    private static final MyTimetableServiceImpl service = new MyTimetableServiceImpl(ConfigUtil.loadConfig());



    public static MyTimetableServiceImpl getService() {
        return service;
    }
}