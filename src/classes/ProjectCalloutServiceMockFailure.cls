@IsTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
    //Implement http mock callout failure here
    global HttpResponse respond(Httprequest request) {
        System.assertEquals('callout:ProjectService',request.getEndpoint());
        HttpResponse response = new Httpresponse();
        String resBody = '[Status=Failure, StatusCode=500]';
        response.setBody(resBody);
        response.setStatusCode(501);
        return response;
    }
}