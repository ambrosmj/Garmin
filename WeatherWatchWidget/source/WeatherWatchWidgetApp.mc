using Toybox.Application as App;
using Toybox.System as Sys;


class WeatherWatchWidgetApp extends App.AppBase {
	hidden var mModel;
    hidden var mView;
    
    //! onStart() is called on application start up
    function onStart() {
    	Sys.println("Creating new WeatherWatchWidgetView");
    	mView = new WeatherWatchWidgetView();
    	Sys.println("WWWV created! WeatherModel is next...");
        mModel = new WeatherModel(mView.method(:onWeather));
        Sys.println("WeatherModel is made!");
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	Sys.println("returning mView");
        return [ mView ];
    }

}