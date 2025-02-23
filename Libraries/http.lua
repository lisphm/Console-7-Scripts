local HttpService = game:GetService("HttpService")
local module = {}

function module.request(command, value)
	local response = HttpService:RequestAsync{
		Url = "https://console-7.lisphm.repl.co",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode{
			command = command,
			value = value,
		}
	}
	if not response.Body then return end
	return HttpService:JSONDecode(response.Body)
end

return module
