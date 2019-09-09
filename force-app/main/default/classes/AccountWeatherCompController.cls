public with sharing class AccountWeatherCompController {
    
    @auraEnabled
    public static String getDetails(id accId){
        Account account = [SELECT Id, ShippingCity FROM Account WHERE Id =:accId];
        
        String accountCity = account.ShippingCity;
        String apiKey = '724f273513e4e45ab701758cae1cd982';
        
        String requestEndpoint = 'http://api.openweathermap.org/data/2.5/weather';
        requestEndpoint += '?q=' + accountCity;
        requestEndpoint += '&units=metric';
        requestEndpoint += '&APPID=' + apiKey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        return http.send(request).getBody();
    }
}