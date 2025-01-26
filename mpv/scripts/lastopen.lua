local utils = require 'mp.utils'
local lastopenFileName = "lastopen.json"

local styleOn = mp.get_property("osd-ass-cc/0")
local styleOff = mp.get_property("osd-ass-cc/1")


-- Check if the operating system is Windows
function isWindows()
  local windir = os.getenv("windir")
  return (windir~=nil)
end


-- Get the filepath of a file from the mpv config folder
local function getFilepath(filename)
  if isWindows() then
  	return os.getenv("APPDATA"):gsub("\\", "/") .. "/mpv/" .. filename
  else	
	return os.getenv("HOME") .. "/.config/mpv/" .. filename
  end
end


local options = {
    path = getFilepath(lastopenFileName)
}

-- Save a table as a JSON file file
-- Returns true if successful
function saveTable(t, path)
  local contents = utils.format_json(t)
  local file = io.open(path .. ".tmp", "wb")
  file:write(contents)
  io.close(file)
  os.remove(path)
  os.rename(path .. ".tmp", path)
  return true
end

function file_exists(path)
  local file = io.open(path, "r")  -- Try to open the file in read mode
  if file then
      file:close()  -- Close the file if it was successfully opened
      return true
  else
      return false
  end
end

local function save_data()
    local data = {
        path = mp.get_property('path'),
        time_pos = mp.get_property_number('time-pos')
    }
    saveTable(data, options.path)
end

function loadData(path)
  local contents = ""
  local myTable = {}
  local file = io.open( path, "r" )
  if file then
    local contents = file:read( "*a" )
    myTable = utils.parse_json(contents);
    io.close(file)
    return myTable
  end
  return nil
end

-- Parses a Windows path with backslashes to one with normal slashes
function parsePath(path)
  if type(path) == "string" then path, _ = path:gsub("\\", "/") end
  return path
end

local function load_data()
    local data = loadData(getFilepath(lastopenFileName))
    if data then
        if data.path and file_exists(data.path) then
          mp.commandv("loadfile", parsePath(data.path), "replace", -1)
          local message = styleOn.."{\\b1}Last Open load:\n"..data.path.."{\\b0}"..styleOff
          mp.osd_message(message)
        elseif not file_exists(data.path) then
            mp.osd_message('File not found: '..data.path)
        else
            mp.osd_message('Failed to parse lastopen.json')
        end
    else
        mp.osd_message('No lastopen.json found')
    end
end

mp.register_event('start-file', save_data)

mp.register_script_message("lastopen", load_data)
