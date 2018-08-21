local PLUGIN = {}

PLUGIN.doc = [[
	/urban <term>
	Returns the first definition for a given term from Urban Dictionary.
]]

PLUGIN.triggers = {
	'^/ud',
	'^/urbandictionary',
	'^/urban'
}

function PLUGIN.action(msg)

	local input = get_input(msg.text)
	if not input then
		if msg.reply_to_message then
			msg = msg.reply_to_message
			input = msg.text
		else
			return send_msg(msg, PLUGIN.doc)
		end
	end

	local url = 'http://api.urbandictionary.com/v0/define?term=' .. URL.escape(input)
	local jstr, res = HTTP.request(url)

	if res ~= 200 then
		return send_msg(msg, config.locale.errors.connection)
	end

	local jdat = JSON.decode(jstr)

	if jdat.result_type == "no_results" then
		return send_msg(msg, config.locale.errors.results)
	end

	message = '"' .. jdat.list[1].word .. '"\n' .. trim_string(jdat.list[1].definition)
	if string.len(jdat.list[1].example) > 0 then
		message = message .. '\n\nExample:\n' .. trim_string(jdat.list[1].example)
	end

	send_msg(msg, message)

end

return PLUGIN
