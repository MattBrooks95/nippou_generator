require 'json'

class FileParser
    def parse(filePath)
        data = JSON.parse(File.read(filePath))
        puts data
        return data
    end
end
