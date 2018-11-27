public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(List <Id> trig) {
        List <Project__c> progFromTrig = [SELECT Id, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE Id IN :trig];
        List <Project__c> projects = new List<Project__c>();
        for (Project__c project : progFromTrig) {
            ServiceCredentials__c s = ServiceCredentials__c.getValues('BillingServiceCredential');
            BillingServiceProxy.project bspProject = new BillingServiceProxy.project();
            bspProject.username = s.Username__c;
            bspProject.password = s.Password__c;
            bspProject.projectid = project.ProjectRef__c;
            bspProject.billAmount = project.Billable_Amount__c;
            BillingServiceProxy.billProjectRequest_element bsp_element = new BillingServiceProxy.billProjectRequest_element();
            bsp_element.project = bspProject;
            BillingServiceProxy.InvoicesPortSoap11 invoice = new BillingServiceProxy.InvoicesPortSoap11();
            invoice.billProject(bsp_element.project);
            List<Project__c> lstProjects = [select id, name, Status__c from Project__c where Id = :project.Id limit 1];
            if (lstProjects.size() > 0) {
                Project__c p = lstProjects[0];
                p.Status__c = 'Billed';
                projects.add(p);
            }
        }
        update projects;
    }
}