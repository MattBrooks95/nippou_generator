#!/C:\Ruby26-x64\bin\ruby
require 'optparse'

require_relative '../NippouGenerator'
require_relative '../NippouOptions'

def toUtf8(someString)
	return someString.encode('UTF-8')
end

commandLineOptions = NippouOptions.new();

OptionParser.new do |options|
	options.banner = 'Usage: main.rb [options]'
	options.on('-fn firstName', '--first firstName', 'first name') do |firstName|
		puts 'saving name'
		commandLineOptions.setFirstName(toUtf8(firstName))
	end

	options.on('-ln lastName', '--last lastName', 'last name') do  |lastName|
		commandLineOptions.setLastName(toUtf8(lastName))
	end

	options.on('-fp CONTENTSFILEPATH', '--filePath CONTENTSFILEPATH', 'Full path to the file that contains nippou body') do |contentsFile|
		commandLineOptions.setContentsFilePath(toUtf8(contentsFile))
	end

	options.on('-fn CONTENTSFILENAME', '--fileName CONTENTSFILENAME', 'Name of contents file in PROJECTROOT/config/userconfigs') do |contentsFileName|
		puts 'CONTENTS FILE NAME UNIMPLEMENTED';
	end

	options.on('-ps MESSAGE', '--postMessage MESSAGE') do |message|
		commandLineOptions.setPostMessage(toUtf8(message))
	end

	options.on('-cf CONFIGFILE', '--configFile CONFIGFILE') do |configFile|
		commandLineOptions.setConfigFilePath(toUtf8(configFile))
	end
end.parse!

configFileOptions = NippouOptions.new();
configFileOptions.setFromOther(commandLineOptions);

[@firstName, @lastName, @contentsFile].each do |option|
	if(option.nil?)
		raise 'Missing parameters! --first firstName --last lastName --file filePath are all necessary! Or, they need to be in the config file!'
	end
end

nippouGenerator = NippouGenerator.new()



[configFileOptionsObject, nippouGenerator].each do |object|
	object.printInspect()
end

# def readFile(contentsFile)
# 	return IO.read(contentsFile, encoding: 'UTF-8')
# end

# bodyContents = @contentsFile.nil? ? '' : readFile(@contentsFile)
# nippou = nippouGenerator.getNippou(@firstName, @lastName)

# if(!@postMessage.nil?)
# 	nippou.setPostMessage(@postMessage)
# end

# if(!@workCodeLine.nil?)
# 	nippou.setWorkCodeLine(@workCodeLine)
# end

# nippou.prepare(bodyContents)
# nippou.output()
