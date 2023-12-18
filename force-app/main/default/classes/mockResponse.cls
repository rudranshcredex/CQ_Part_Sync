/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class mockResponse implements HttpCalloutMock{
    
    public HttpResponse respond(HttpRequest request) {
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id":"619683d69402c24f000237e9","Part Name":"Population Sensor","Total Quantity Shipped":350000},{"_id":"619643769402c24f000229ec","Part Name":"Drill Gauge","Total Quantity Shipped":125000},{"_id":"629989816a50f02a0000b83e","Part Name":"Pressure Adapt","Total Quantity Shipped":12},{"_id":"619643919402c24f000229ef","Part Name":"Population Sensor","Total Quantity Shipped":125000},{"_id":"62998ecc6a50f02a0000b87d","Part Name":"Pressure Sensor","Total Quantity Shipped":100}]');
        response.setStatusCode(200);
        return response;
    }
}