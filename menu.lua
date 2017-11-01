local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )


-- -----------------------------------------------------------------------------------
-- The generic functions will go at the top of the screen
-- -- -----------------------------------------------------------------------------------
local function dragBasket (event)
 local bskTarget = event.target
 local phase = event.phase
 

 if ( event.phase == "began" ) then
   transition.to (basket, {time= 500, x = event.x})
  return true
end
end

local function basketCollision(self, event)
	if ( event.phase == "began" ) then
	  if ( event.target.type == "basket")  and (event.other.type == "coin") then
	  	score = score + 5  
		scoreText.text = score	
	  else
		local options =
		 {
		  params = {
		   passValue = scoreText.text
		  }
		 }
		-- This line will remove the basket and  
		Runtime:removeEventListener( "enterFrame", event.self )
		event.target:removeSelf()
 		timer.cancel(eventTimer)
 		composer.showOverlay("scene2", options)
	  end
	end
end

local function coinClicked(event)
if ( event.phase == "began" ) then
Runtime:removeEventListener( "enterFrame", event.self )
event.target:removeSelf()
end
end

-- when the bomb is clicked, half the score 
local function bombClicked(event)
if ( event.phase == "began" ) then
Runtime:removeEventListener( "enterFrame", event.self )
event.target:removeSelf()


end
end

-- Delete objects which has fallen off the bottom of the screen
local function offscreen(self, event)
if(self.y == nil) then
return
end
if(self.y > display.contentHeight + 50) then
Runtime:removeEventListener( "enterFrame", self )
self:removeSelf()
end
end

-- Add a new falling coin or- bomb
local function addNewCoinOrBomb()
local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	if(math.random(1,5)==1) then
		-- BOMB!
		bomb = display.newImage( "bomb.png", startX, -100)
		bomb:scale( 0.8, 0.8 )
		physics.addBody(bomb)
		bomb.type = "bomb"
		bomb.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", bomb )
		bomb:addEventListener( "touch", bombClicked )
		sceneGroup:insert(bomb)
	else
		-- Balloon
		coin = display.newImage( "coin.png", startX, -100)
		coin:scale( 0.8, 0.8 )
		physics.addBody( coin )
		coin.type = "coin"
		coin.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", coin )
		coin:addEventListener( "touch", coinClicked )
		sceneGroup:insert( coin )
	end
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
 
 local sceneGroup = self.view
 -- Code here runs when the scene is first created but has not yet appeared on screen

	
end


-- show()
function scene:show( event )
 sceneGroup = self.view
 local phase = event.phase
 
 if ( phase == "will" ) then
 	 physics.start()
	-- physics.setDrawMode("hybrid") 

  -- Code here runs when the scene is still off screen (but is about to come on screen)
  local background = display.newImage( "bkg.jpg", display.contentWidth*0.5, display.contentHeight*0.5 )
  background:addEventListener( "touch", dragBasket )
  sceneGroup:insert(background)
  score = 0
  scoreText = display.newText(score, display.contentWidth*0.5, 40)
  sceneGroup:insert(scoreText)
  
  basket = display.newImage( "basket.png", display.contentWidth*0.5, display.contentHeight )
    basket:scale( 0.2, 0.2 )
	basket.type = "basket"
	basket.collision = basketCollision
	basket:addEventListener( "collision", basket )
	physics.addBody(basket, "static", {density=1, friction=5, radius=30})
	sceneGroup:insert(basket)
	

  addNewCoinOrBomb() 
  eventTimer = timer.performWithDelay( 500, addNewCoinOrBomb, 0 )
  elseif ( phase == "did" ) then
  -- Code here runs when the scene is entirely on screen
 end
end


-- hide()
function scene:hide( event )
 
 local sceneGroup = self.view
 local phase = event.phase
 local parent = event.parent  
 if ( phase == "will" ) then
  -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
  -- Code here runs immediately after the scene goes entirely off screen
  
 end
end


-- destroy()
function scene:destroy( event )
 
 local sceneGroup = self.view
 composer.removeScene( "menu" )
 -- Code here runs prior to the removal of scene's view


end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
