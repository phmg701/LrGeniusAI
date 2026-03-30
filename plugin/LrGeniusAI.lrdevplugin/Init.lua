---@diagnostic disable: undefined-global

-- Global imports
_G.LrHttp = import 'LrHttp'
_G.LrDate = import 'LrDate'
_G.LrPathUtils = import 'LrPathUtils'
_G.LrFileUtils = import 'LrFileUtils'
_G.LrTasks = import 'LrTasks'
_G.LrErrors = import 'LrErrors'
_G.LrDialogs = import 'LrDialogs'
_G.LrView = import 'LrView'
_G.LrBinding = import 'LrBinding'
_G.LrColor = import 'LrColor'
_G.LrFunctionContext = import 'LrFunctionContext'
_G.LrApplication = import 'LrApplication'
_G.LrPrefs = import 'LrPrefs'
_G.LrProgressScope = import 'LrProgressScope'
_G.LrExportSession = import 'LrExportSession'
_G.LrStringUtils = import 'LrStringUtils'
_G.LrMD5 = import 'LrMD5'
_G.LrLocalization = import 'LrLocalization'
_G.LrShell = import 'LrShell'
_G.LrSystemInfo = import 'LrSystemInfo'
_G.LrApplicationView = import 'LrApplicationView'

_G.JSON = require "JSON"

require "Util"
require "Defaults"

-- Global initializations
_G.prefs = _G.LrPrefs.prefsForPlugin()
_G.log = import 'LrLogger' ('LrGeniusAI')
_G.prefs.logging = true
_G.log:enable('logfile') -- Always enable logging to a file

if _G.prefs.ai == nil then
    _G.prefs.ai = ""
end

if _G.prefs.geminiApiKey == nil then
    _G.prefs.geminiApiKey = ""
end

if _G.prefs.chatgptApiKey == nil then
    _G.prefs.chatgptApiKey = ""
end

if _G.prefs.vertexProjectId == nil then
    _G.prefs.vertexProjectId = ""
end

if _G.prefs.vertexLocation == nil then
    _G.prefs.vertexLocation = "us-central1"
end

if _G.prefs.generateTitle == nil then
    _G.prefs.generateTitle = true
end

if _G.prefs.generateKeywords == nil then
    _G.prefs.generateKeywords = true
end

if _G.prefs.generateCaption == nil then
    _G.prefs.generateCaption = true
end

if _G.prefs.generateAltText == nil then
    _G.prefs.generateAltText = true
end

if _G.prefs.enableValidation == nil then
    _G.prefs.enableValidation = true
end

if _G.prefs.showCosts == nil then
    _G.prefs.showCosts = true
end

if _G.prefs.generateLanguage == nil then
    _G.prefs.generateLanguage = Defaults.defaultGenerateLanguage
end

if _G.prefs.bilingualKeywords == nil then
    _G.prefs.bilingualKeywords = Defaults.defaultBilingualKeywords
end

if _G.prefs.keywordSecondaryLanguage == nil then
    _G.prefs.keywordSecondaryLanguage = Defaults.defaultKeywordSecondaryLanguage
end

if _G.prefs.replaceSS == nil then
    _G.prefs.replaceSS = false
end

if _G.prefs.exportSize == nil then
    _G.prefs.exportSize = Defaults.defaultExportSize
end

if _G.prefs.exportQuality == nil then
    _G.prefs.exportQuality = Defaults.defaultExportQuality
end

if _G.prefs.usePreviewThumbnails == nil then
    _G.prefs.usePreviewThumbnails = true
end

if _G.prefs.showPhotoContextDialog == nil then
    _G.prefs.showPhotoContextDialog = true
end

if _G.prefs.submitKeywords == nil then
    _G.prefs.submitKeywords = true
end

if _G.prefs.submitGPS == nil then
    _G.prefs.submitGPS = true
end

if _G.prefs.temperature == nil then
    _G.prefs.temperature = Defaults.defaultTemperature
end

if _G.prefs.useKeywordHierarchy == nil then
    _G.prefs.useKeywordHierarchy = true
end

if _G.prefs.useTopLevelKeyword == nil then
    _G.prefs.useTopLevelKeyword = true
end

if _G.prefs.prompts == nil then
    _G.prefs.prompts = { Default = Defaults.defaultSystemInstruction }
end

if _G.prefs.prompt == nil then
    _G.prefs.prompt = Defaults.defaultPromptName
end

if _G.prefs.ollamaBaseUrl == nil then
    _G.prefs.ollamaBaseUrl = Defaults.defaultOllamaBaseUrl
end

if _G.prefs.lmstudioBaseUrl == nil then
    _G.prefs.lmstudioBaseUrl = Defaults.defaultLmStudioBaseUrl
end

if _G.prefs.backendServerUrl == nil or _G.prefs.backendServerUrl == "" then
    _G.prefs.backendServerUrl = Defaults.defaultBackendServerUrl
end

if _G.prefs.periodicalUpdateCheck == nil then
    _G.prefs.periodicalUpdateCheck = false
end

if _G.prefs.submitFolderName == nil then
    _G.prefs.submitFolderName = false
end

if _G.prefs.useGlobalPhotoId == nil then
    _G.prefs.useGlobalPhotoId = true
end

if _G.prefs.useLightroomKeywords == nil then
    _G.prefs.useLightroomKeywords = false
end

if _G.prefs.topLevelKeyword == nil then
    _G.prefs.topLevelKeyword = Defaults.defaultTopLevelKeyword
end

if _G.prefs.knownTopLevelKeywords == nil then
    _G.prefs.knownTopLevelKeywords = Defaults.defaultTopLevelKeywords
end

if _G.prefs.useClip == nil then
    _G.prefs.useClip = false
end

-- Advanced Search dialog options (persisted for convenience)
if _G.prefs.searchScope == nil then
    _G.prefs.searchScope = "all"
end
if _G.prefs.searchInSemanticSiglip == nil then
    _G.prefs.searchInSemanticSiglip = true
end
if _G.prefs.searchInSemanticVertex == nil then
    _G.prefs.searchInSemanticVertex = true
end
if _G.prefs.searchInMetadata == nil then
    _G.prefs.searchInMetadata = true
end
if _G.prefs.searchInMetadataKeywords == nil then
    _G.prefs.searchInMetadataKeywords = true
end
if _G.prefs.searchInMetadataCaption == nil then
    _G.prefs.searchInMetadataCaption = true
end
if _G.prefs.searchInMetadataTitle == nil then
    _G.prefs.searchInMetadataTitle = true
end
if _G.prefs.searchInMetadataAltText == nil then
    _G.prefs.searchInMetadataAltText = true
end

function _G.JSON.assert(b, m)
    LrDialogs.showError("Error decoding JSON response.")
end

local function ensureMacOSServerUnquarantined()
    log:info("ensureMacOSServerUnquarantined: starting")
    log:info("ensureMacOSServerUnquarantined: MAC_ENV = " .. tostring(MAC_ENV) .. ", prefs._serverUnquarantined = " .. tostring(prefs._serverUnquarantined))
    
    if not MAC_ENV then 
        log:info("ensureMacOSServerUnquarantined: not macOS, skipping")
        return 
    end
    
    local serverDir = LrPathUtils.child(LrPathUtils.parent(_PLUGIN.path), "lrgenius-server")
    local serverBinary = LrPathUtils.child(serverDir, "lrgenius-server")
    log:info("ensureMacOSServerUnquarantined: serverDir = " .. serverDir)
    log:info("ensureMacOSServerUnquarantined: serverBinary = " .. serverBinary)
    
    if not LrFileUtils.exists(serverBinary) then
        log:info("ensureMacOSServerUnquarantined: server binary not found, skipping")
        return
    end
    
    local checkCmd = 'xattr -p com.apple.quarantine "' .. serverBinary .. '" 2>/dev/null; echo "EXIT:$?"'
    log:info("ensureMacOSServerUnquarantined: checking quarantine with: " .. checkCmd)
    local checkOutput = LrTasks.execute(checkCmd)
    log:info("ensureMacOSServerUnquarantined: check output = " .. tostring(checkOutput))
    
    local checkResult = tonumber(string.match(checkOutput, "EXIT:(%d+)")) or -1
    log:info("ensureMacOSServerUnquarantined: check exit code = " .. checkResult)
    
    if checkResult ~= 0 then
        log:info("ensureMacOSServerUnquarantined: binary not quarantined, done")
        prefs._serverUnquarantined = true
        return
    end
    
    log:info("ensureMacOSServerUnquarantined: quarantine attribute found on actual binary")
    
    log:info("ensureMacOSServerUnquarantined: removing quarantine attribute...")
    local removeCmd = 'xattr -d com.apple.quarantine "' .. serverBinary .. '" 2>&1; echo "REMOVE_EXIT:$?"'
    local removeOutput = LrTasks.execute(removeCmd)
    log:info("ensureMacOSServerUnquarantined: remove output = " .. tostring(removeOutput))
    
    local removeResult = tonumber(string.match(removeOutput, "REMOVE_EXIT:(%d+)")) or -1
    
    if removeResult == 0 then
        local verifyOutput = LrTasks.execute(checkCmd)
        local verifyResult = tonumber(string.match(verifyOutput, "EXIT:(%d+)")) or -1
        log:info("ensureMacOSServerUnquarantined: verify exit code = " .. verifyResult)
        
        if verifyResult ~= 0 then
            log:info("ensureMacOSServerUnquarantined: verified - quarantine attribute removed successfully")
            prefs._serverUnquarantined = true
        else
            log:warn("ensureMacOSServerUnquarantined: quarantine attribute still present after removal")
        end
    else
        log:warn("ensureMacOSServerUnquarantined: removal failed with exit code " .. removeResult)
    end
    
    log:info("ensureMacOSServerUnquarantined: done")
end

if prefs.periodicalUpdateCheck then
    LrTasks.startAsyncTask(function()
        -- Check for updates in the background
        UpdateCheck.checkForNewVersionInBackground()
    end)
end

LrTasks.startAsyncTask(function()
    ensureMacOSServerUnquarantined()
    SearchIndexAPI.startServer()
    if prefs.enableOpenClip then
        SearchIndexAPI.isClipReady() -- To trigger load of the CLIP model.
    end
end)


require "MetadataManager"
require "KeywordConfigProvider"
require "PromptConfigProvider"
require "UpdateCheck"
require "ErrorHandler"
require "APISearchIndex"
require "PhotoSelector"
