@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    @testSetup static void setup() {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account' ;
        insert testAccount;
        Opportunity testOpportunity = new Opportunity(
                StageName = 'Yet to begin',
                CloseDate = Date.newInstance(2018, 12, 31),
                Account = testAccount,
                Name = 'Test Opportunity Triggers'

        );
        insert testOpportunity;
        Project__c p = new Project__c(
                Name = 'Test Project',
                Opportunity__c = testOpportunity.Id,
                ProjectRef__c = 'ProjectRefUniqueCode',
                Status__c = 'Billable',
                Billable_Amount__c = 10,
                End_Date__c = Date.newInstance(2018, 12, 31),
                Start_Date__c = Date.newInstance(2017, 12, 31)
        );
        insert p;
    }

    @IsTest
    static void testDoPostInsert() {
        List<Opportunity> lstOps = [
                SELECT Id, name
                FROM Opportunity
                LIMIT 1
        ];
        Opportunity o = new Opportunity();
        if (lstOps.size() > 0) {
            o = lstOps[0];
        }
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = 'https://playful-raccoon-bsxal4-dev-ed.salesforce.com/services/apexrest/project';
        req.httpMethod = 'POST';
        Test.StartTest();
        RestContext.request = req;
        RestContext.response = res;
        String results =
                ProjectRESTService.postProjectData('ProjectRef2ndCode',
                        'Project Name 02',
                        o.Id,
                        Date.newInstance(2018, 12, 31),
                        Date.newInstance(2018, 12, 31),
                        10,
                        'Billable');
        Test.StopTest();
        System.assertEquals('OK', results);



    }

    @IsTest
    static void testDoPostUpdate() {
        List<Opportunity> lstOps = [
                SELECT Id, name
                FROM Opportunity
                LIMIT 1
        ];
        Opportunity o = new Opportunity();
        if (lstOps.size() > 0) {
            o = lstOps[0];
        }
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = 'https://playful-raccoon-bsxal4-dev-ed.salesforce.com/services/apexrest/project';
        req.httpMethod = 'POST';
        Test.StartTest();
        RestContext.request = req;
        RestContext.response = res;
        String results =
                ProjectRESTService.postProjectData('ProjectRef2ndCode',
                        'Project Name 01',
                        o.Id,
                        Date.newInstance(2018, 12, 31),
                        Date.newInstance(2018, 12, 31),
                        100,
                        'Billable');
        results =
                ProjectRESTService.postProjectData('ProjectRef2ndCode',
                        'Project Name 01',
                        o.Id,
                        Date.newInstance(2018, 12, 31),
                        Date.newInstance(2018, 12, 31),
                        100,
                        'Billable');
        Test.StopTest();
        System.assertEquals('OK', results);

    }
}