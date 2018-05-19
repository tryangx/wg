--
--
--
--
--

require "DataUtility"
require "DebugUtility"
require "FileUtility"
require "HelperUtility"
require "InputUtility"
require "LocalizeUtility"
require "LogUtility"
require "MathUtility"
require "MenuUtility"
require "ProfileUtility"
require "RandomizerUtility"
require "PathUtility"
require "StringUtility"

-----------------------------------
require "socket"
function Util_Sleep( time )
   socket.select( nil, nil, time )
end
-----------------------------------