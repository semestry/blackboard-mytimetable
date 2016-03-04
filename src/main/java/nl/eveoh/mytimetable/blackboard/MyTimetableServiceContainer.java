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