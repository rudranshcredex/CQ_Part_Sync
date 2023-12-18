/**
 * @description       : 
 * @author            : Rudransh Shukla
 * @group             : 
 * @last modified on  : 12-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class getRecordsTest {
    @isTest
    private static void getRecordsMethodTest() {
        Test.setMock(HttpCalloutMock.class, new mockResponse());
        Boolean result = getRecords.getRecordsMethod();
        system.assertEquals(result, false);    
    }
}