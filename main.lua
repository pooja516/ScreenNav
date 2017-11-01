local storyboard = require "composer"
local widget = require( "widget" )

--storyboard.gotoScene("menu")


-- Flip the image vertically and horizontally
--star:scale( 0.1, 0.1)

--transition.to( star, { rotation = star.rotation-360, time=2000, onComplete=spinImage } )
 
local bkg = display.newImage( "coin-collector.png", display.contentWidth*0.5, display.contentHeight*0.5 )
 
--local bkg1 = display.newImage("start.png", 160,400)
-- Function to handle button events
local function handleButtonEvent( event ) 
    if ( "ended" == event.phase ) then
		Runtime:removeEventListener( "enterFrame", event.self )
		event.target:removeSelf()
		bkg:removeSelf()
		bkg = nil
       storyboard.gotoScene("menu")
    end
end
 
local button1 = widget.newButton(
    {
        defaultFile = "start.png",
        onEvent = handleButtonEvent
    }
)
 
-- Center the button
button1.x = 160
button1.y = 400


