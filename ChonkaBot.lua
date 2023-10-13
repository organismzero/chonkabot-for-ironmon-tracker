local function ChonkaBot()
    local json = require("json")
    local self = {}

	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	self.name = "ChonkaBot"
	self.author = "OrganismZero"
	self.description = "An extension for Ironmon Tracker to provide information to ChonkaBot for stream integration."
	self.version = "1.0"
	self.url = "https://github.com/organismzero/chonkabot-for-ironmon-tracker" -- Remove or set to nil if no host website available for this extension

	self.apiEndpoint = "https://chonka.automationbot.app/api/ironmon-tracker"

	-- Executed when the user clicks the "Options" button while viewing the extension details within the Tracker's UI
	-- Remove this function if you choose not to include a way for the user to configure options for your extension
	-- NOTE: You'll need to implement a way to save & load changes for your extension options, similar to Tracker's Settings.ini file
	function self.configureOptions()
		-- [ADD CODE HERE]
	end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		-- Replace "MyUsername" and "ExtensionRepo" in the below URL to match your repo url
		local versionCheckUrl = "https://api.github.com/repos/organismzero/chonkabot-for-ironmon-tracker/releases/latest"
		-- Update the pattern below to match your version. You can check what this looks like by visiting the above url
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"'
		-- Replace "MyUsername" and "ExtensionRepo" in the below URL to match your repo url
		local downloadUrl = "https://github.com/organismzero/chonkabot-for-ironmon-tracker/releases/latest"

		local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, nil)
		return isUpdateAvailable, downloadUrl
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		-- [ADD CODE HERE]
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames, after any battle related data from game memory is read in
	function self.afterBattleDataUpdate()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames or after any redraw event is scheduled (i.e. most button presses)
	function self.afterRedraw()
		-- [ADD CODE HERE]
	end

	-- Executed before a button's onClick() is processed, and only once per click per button
	-- Param: button: the button object being clicked
	function self.onButtonClicked(button)
		-- [ADD CODE HERE]
	end

	-- Executed after a new battle begins (wild or trainer), and only once per battle
	function self.afterBattleBegins()
		-- [ADD CODE HERE]
        local payload, err = json.encode({
            attempts = Main.currentSeed
        })
        if err then error(err) end

        local resp, err = comm.httpPost(self.apiEndpoint .. "", payload)
        if err then error(err) end

		if resp ~= nil then
			local attemptsWrite = io.open("chonkabot-response.json", "w")
			if attemptsWrite ~= nil then
				local output = resp
				attemptsWrite:write(output)
				attemptsWrite:close()
			end
		end
	end

	-- Executed after a battle ends, and only once per battle
	function self.afterBattleEnds()
		-- [ADD CODE HERE]
	end

	return self
end
return ChonkaBot
