-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Leap = { "ggandor/leap.nvim" }

Leap.config = function()
    require('leap').add_default_mappings()
end

return Leap
