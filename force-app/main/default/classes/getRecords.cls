/**
* @description       : 
* @author            : Rudransh Shukla
* @group             : 
* @last modified on  : 12-15-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class getRecords {
    @AuraEnabled(cacheable=true)
    public static void  getRecordsMethod() {
        
        Boolean hasCustomPermission = FeatureManagement.checkPermission('Access_Sync_Service');
        
        if(hasCustomPermission){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://cqparts-3d06.restdb.io/rest/cqpart?x-api-key=b96d75ce0f9f342d10af6710ef8ea7ed0ad06';
            String key = 'x-api-key';
            String value = 'b96d75ce0f9f342d10af6710ef8ea7ed0ad06';
            
            request.setEndpoint(endpoint);
            request.setHeader(key, value);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            List<Object> results = new List<Object>();
            
            if (response.getStatusCode() == 200) {
                results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('results---------->' + results);
            }
            
            Integer totalQuantityShipped = 0; 
            id lowId = [select id from account where name='Low Volume' limit 1].id;
            id highId = [select id from account where name='High Volume' limit 1].id;
            
            list<SQX_Part__c> cqPartList = new list<SQX_Part__c>();
            
            boolean alreadyExists = false;
            if([select count() from SQX_Part__c]>0){
                alreadyExists = true;
            }
            
            
                for (Object result : results) {
                    Map<String, Object> record = (Map<String, Object>) result;
                    System.debug('record------->' + record);
                    
                    
                    if (record.containsKey('Total Quantity Shipped')) {
                        totalQuantityShipped = (Integer) record.get('Total Quantity Shipped');
                        
                        system.debug('totalQuantityShipped--------->'+totalQuantityShipped);
                        if (totalQuantityShipped >= 99) {
                            
                            
                            SQX_Part__c rec = new SQX_Part__c(
                                name='CQ_Part',
                                Active__c = true,
                                Part_Number__c = (string)record.get('_id'),
                                Related_Account__c = lowId
                            );
                            cqPartList.add(rec);
                            
                            system.debug('insert low');
                        }
                        else if(totalQuantityShipped<99){
                            
                            SQX_Part__c rec = new SQX_Part__c(
                                name='CQ_Part',
                                Active__c = true,
                                Part_Number__c = (string)record.get('_id'),
                                Related_Account__c = highId
                            );
                            cqPartList.add(rec);
                            
                            system.debug('insert low');
                        }
                    }
                    
                }
            if(!cqPartList.isEmpty() && !alreadyExists){
                insert cqPartList;
                system.debug('end');
            }
        }
    }
}