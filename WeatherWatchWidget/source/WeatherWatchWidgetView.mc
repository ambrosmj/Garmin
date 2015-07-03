using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Position;

class Weather
{
    var temperature;
    var city;
}

class WeatherModel
{
    hidden var notify;

    function kelvinToFarenheight(kelvin)
    {
        return ( (9 * (kelvin - 273) ) / 5.0 ) + 32;
    }

    function onPosition(info)
    {
        var latLon = info.position.toDegrees();

        Sys.println(latLon[0].toString());
        Sys.println(latLon[1].toString());
		Sys.println("Before Comm request");
        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>latLon[0].toFloat(), "lon"=>latLon[1].toFloat()}, {}, method(:onReceive));
		
        notify.invoke("Loading\nWeather");
    }

    function initialize(handler)
    {
    	Sys.println("Initilizing");
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        notify = handler;
    }

    function onReceive(responseCode, data)
    {
        if( responseCode == 200 )
        {
            var weather = new Weather();
            weather.city = data["name"];
            weather.temperature = kelvinToFarenheight(data["main"]["temp"]);
            Sys.println(weather.city);
            Sys.println(weather.temperature);
            notify.invoke(weather);
        }
        else
        {
            notify.invoke( "Failed to load\nError: " + responseCode.toString() );
        }
    }

}

class WeatherWatchWidgetView extends Ui.View {

	hidden var mWeather = "Farts";
    hidden var mModel;
    
    //! Load your resources here
    function onLayout(dc) {
    Sys.println("Loading assest...");
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
   //     View.onUpdate(dc);
		Sys.println("Drawing to screen");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mWeather, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        //In this section draw a series of trapezoids in different colors
		dc.setPenWidth(10);
		dc.setColor(Graphics.COLOR_PURPLE,Graphics.COLOR_PURPLE);
		dc.drawLine(5,15,50,50);
		
//		dc.drawBitmap(0, 0, "../resources/images/monkey.png");
		// end section
        Sys.println("Draw complete!");
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
	function onWeather(weather)
    {
    	Sys.println("In onWeather...");
        if (weather instanceof Weather)
        {
            mWeather = Lang.format("City: $1$\nTemp: $2$", [weather.city, weather.temperature]);
        }
        else if (weather instanceof Lang.String)
        {
            mWeather = weather;
        }
        Ui.requestUpdate();
    }
}
