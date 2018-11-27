@IsTest
global class ProjectCalloutServiceMock implements HttpCalloutMock{
   //Implement http mock callout here
    global HttpResponse respond(Httprequest request){
        System.assertEquals('callout:ProjectService',request.getEndpoint());
        HttpResponse response = new Httpresponse();
        String resBody = '[Status=Created, StatusCode=201]';
        response.setHeader('Content-Type','application/json');
        response.setBody(resBody);
        response.setStatusCode(201);
        return response;
    }
}