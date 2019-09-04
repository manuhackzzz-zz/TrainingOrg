public class AWC_Wrapper_master {
    
    public integer id;
    public string name;
    public integer cod; 
    public AWC_coordWrapper coord;
    public List<AWC_listSingleWeatherWrapper> weather;
    public string base;
    public AWC_mainWrapper main;
    public integer visibility;
    public AWC_windWrapper wind;
    public AWC_cloudsWrapper cloud;
    public AWC_sysWrapper sys;
    public integer dt;
    
    public class AWC_coordWrapper {
        public decimal lon;
        public decimal lat;
    }
    
    public class AWC_listSingleWeatherWrapper {
        public integer id;
        public string main;
        public string description;
        public string icon;        
    }
    
    public class AWC_mainWrapper {
        public decimal temp;
        public integer pressure;
        public integer humidity;
        public decimal temp_min;
        public decimal temp_max;        
    }
    
    public class AWC_windWrapper {
        public decimal speed;
        public integer deg;
    }
    
    public class AWC_cloudsWrapper {
        public integer all;
    }
    
    public class AWC_sysWrapper {
        public integer type;
        public integer id;
        public decimal message;
        public string country;
        public integer sunrise;
        public integer sunset;       
    }
    
    
}