trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            List <Id> projectsToUpdate = new List<Id>();
            for (Project__c proj : Trigger.new) {
                if ((proj.Status__c == 'Billable') && (Trigger.oldMap.get(proj.Id).Status__c != 'Billable')) {
                    projectsToUpdate.add(proj.Id);
                }
            }
            if (projectsToUpdate.size() > 0) {
                BillingCalloutService.callBillingService(projectsToUpdate);
            }
        }
    }
}
