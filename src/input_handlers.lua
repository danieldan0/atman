function handle_input(user_input)
  -- Movement keys
  if user_input.keys['up'] then
    return {move = {0, -1}}
  elseif user_input.keys['down'] then
    return {move = {0, 1}}
  elseif user_input.keys['left'] then
    return {move = {-1, 0}}
  elseif user_input.keys['right'] then
    return {move = {1, 0}}
  end

  if user_input.keys['return'] and user_input.keys['lalt'] then
    -- Alt+Enter: toggle full screen
    return {fullscreen = true}
  elseif user_input.keys['escape'] then
    -- Exit the game
    return {exit = true}
  end

  -- No key was pressed
  return {}
end

return handle_input
