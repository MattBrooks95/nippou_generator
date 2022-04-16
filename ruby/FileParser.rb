require 'json'

class FileParser
	def parse(filePath)
		data = JSON.parse(File.read(filePath,encoding: "UTF-8"))
		return data
	end
end
