public with sharing class AccountWeatherController {
    
    public String city {get;set;}
    public Decimal temp {get;set;}
    public Integer pressure {get;set;}
    public Integer humidity {get;set;}
    public Decimal temp_min {get;set;}
    public Decimal temp_max {get;set;}
    public String description {get;set;}
        
    public AccountWeatherController(){
        
    }
    
    public AccountWeatherController(ApexPages.StandardController stdController) {
        Account account = (Account)stdController.getRecord();
        account = [SELECT Id, ShippingCity FROM Account WHERE Id =:account.Id];
        
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
        HttpResponse response = http.send(request);
        system.debug(JSON.deserializeUntyped(response.getBody()));
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            
            // Deserialize the JSON string into collections of primitive data types.
            AWC_Wrapper_master results = (AWC_Wrapper_master)JSON.deserialize(response.getBody(),AWC_Wrapper_master.class);
            system.debug('results @@@ ' + results);
            
            description = results.weather[0].description;
            city = results.name;
            temp = results.main.temp;
            pressure = results.main.pressure;
            humidity = results.main.humidity; 
            temp_min = results.main.temp_min;
            temp_max = results.main.temp_max;            
            
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
            ApexPages.addMessage(myMsg);
        }
        
        
    }
}