@isTest(SeeAllData = true)
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here
    @isTest
    public static void testSuccess() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',
                AccountId = acc.id, CloseDate = System.Today(),
                Amount = 12480.00,
                Type = 'New Project',
                StageNAme = 'Qualification');
        insert opp;
        List<Id> oppts = new List<Id>{opp.id};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(oppts);
        Test.stopTest();
    }

    @isTest
    public static void testFailure() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'Test Opportunity',
                AccountId = acc.id, CloseDate = System.Today(),
                Amount = 12480.00,
                Type = 'New Project',
                StageNAme = 'Qualification');
        insert opp;

        List<Id> oppts = new List<Id>{opp.id };
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(oppts);
        Test.stopTest();
    }
}