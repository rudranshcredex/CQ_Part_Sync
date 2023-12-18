/**
* @description       : 
* @author            : Rudransh Shukla
* @group             : 
* @last modified on  : 12-18-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class getRecords {
    @AuraEnabled(cacheable=true)
    public static boolean  getRecordsMethod() {
        
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

            boolean alreadyExists = false;
            if([select count() from SQX_Part__c]>0){
                alreadyExists = true;
            }
            
            if (response.getStatusCode() == 200) {
                results = (List<Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('results---------->' + results);
            }
            
            Integer totalQuantityShipped = 0; 
            Id lowId;
            Id highId;
            List<Account> lowVolumeAccounts = [SELECT Id FROM Account WHERE Name = 'Low Volume' LIMIT 1];
            if (!lowVolumeAccounts.isEmpty()) {
                lowId = lowVolumeAccounts[0].Id;
            }
            List<Account> highVolumeAccounts = [SELECT Id FROM Account WHERE Name = 'High Volume' LIMIT 1];
            if (!highVolumeAccounts.isEmpty()) {
                highId = highVolumeAccounts[0].Id;
            }

            
            list<SQX_Part__c> cqPartList = new list<SQX_Part__c>();
            
           
            if(!alreadyExists){
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
                if(!cqPartList.isEmpty()){
                    insert cqPartList;
                    system.debug('end');
                   
                }

            }
            else {
                system.debug('already Exists');
                
            }
        return alreadyExists;
            
        }
        return false;
    }
}