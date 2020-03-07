#!/C:\Ruby26-x64\bin\ruby
require 'optparse'

require_relative '../Nippou'
require_relative '../NippouOptions'

def toUtf8(someString)
	return someString.encode('UTF-8')
end

commandLineOptions = NippouOptions.new()

OptionParser.new do |options|
	options.banner = 'Usage: main.rb [options]'
	options.on('-f firstName', '--first firstName', 'first name') do |firstName|
		puts 'saving name'
		commandLineOptions.setFirstName(toUtf8(firstName))
	end

	options.on('-l lastName', '--last lastName', 'last name') do  |lastName|
		commandLineOptions.setLastName(toUtf8(lastName))
	end

	options.on('-c CONTENTSFILEPATH', '--filePath CONTENTSFILEPATH', 'Full path to the file that contains nippou body') do |contentsFile|
		commandLineOptions.setContentsFilePath(toUtf8(contentsFile))
	end

	options.on('-m MESSAGE', '--postMessage MESSAGE', 'personable parting message, at very end of email') do |message|
		commandLineOptions.setPostMessage(toUtf8(message))
	end

	options.on('-p CONFIGFILEPATH', '--configFilePath CONFIGFILEPATH', 'full path to configuration file') do |configFilePath|
		commandLineOptions.setConfigFilePath(toUtf8(configFilePath))
	end

	options.on('-n CONFIGFILENAME', '--fileName CONFIGFILENAME', 'Name of config file in PROJECTROOT/config/userconfigs') do |configFileName|
		puts 'CONFIG FILE NAME UNIMPLEMENTED';
		commandLineOptions.setConfigFileName(configFileName)
	end
end.parse!

nippou = Nippou.new(commandLineOptions)
nippou.prepare()
nippou.output()
# bodyContents = @contentsFile.nil? ? '' : readFile(@contentsFile)
# nippou = nippouGenerator.getNippou(@firstName, @lastName)

# if(!@workCodeLine.nil?)
# 	nippou.setWorkCodeLine(@workCodeLine)
# end

# nippou.prepare(bodyContents)
# nippou.output()
