global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List <Id> opportunityId) {
        List <Opportunity> opportunityList = [
                SELECT ID,Name,Account.Name,CloseDate,Amount
                FROM Opportunity
                WHERE Id in :opportunityId
                Limit 1
        ];
        Opportunity opp = new Opportunity();
        String jsonInput = '';
        if (opportunityList.size() > 0) {
            opp = opportunityList.get(0);
            jsonInput = '{\n' +
                    ' "opportunityId" : "' + opp.Id + '",\n' +
                    ' "opportunityName" : "' + opp.Name + '",\n' +
                    ' "accountName" : "' + opp.Account.Name + '",\n' +
                    ' "closeDate" : "' + String.ValueOf(opp.CloseDate) + '",\n' +
                    ' "amount" : ' + opp.Amount.setScale(0) + '\n' +
                    '}';
        }
        ID jobID = System.enqueueJob(new QueueablePMSCall(jsonInput, opp));

    }

    global class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private final String json;
        private Opportunity opp;

        public QueueablePMSCall(String json, Opportunity opp) {
            this.json = json;
            this.opp = opp;
        }

        global void execute(QueueableContext context) {
            ServiceTokens__c s = ServiceTokens__c.getValues('ProjectServiceToken');
            HTTPRequest req = new HTTPRequest();
            req.setEndPoint('callout:ProjectService');
            req.setMethod('POST');
            req.setHeader('token', s.Token__c);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setBody(json);
            Http h = new Http();
            HttpResponse response = h.send(req);
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());
                opp.StageName = 'Resubmit Project';
            } else {
                System.debug('Response body: ' + response.getBody());
                opp.StageName = 'Submitted Project';
            }
            update opp;
        }
    }
}