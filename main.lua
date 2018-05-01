function love.load() --资源加载回调函数，仅初始化时调用一次

end

function love.draw() --绘图回调函数，每周期调用
	love.graphics.print( "Hello world" )
end

function love.update(dt) --更新回调函数，每周期调用

end

function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用


end