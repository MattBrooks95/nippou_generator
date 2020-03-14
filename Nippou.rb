require 'date'
require 'pp'


require_relative './NippouOptions'

class Nippou
	OPTION_ADDRESSES             = "addresses"
	OPTION_FIRST_NAME            = "firstName"
	OPTION_LAST_NAME             = "lastName"
	OPTION_MIDDLE_NAME           = "middleName"
	OPTION_FULL_NAME_OVERRIDE    = "fullNameOverride"
	OPTION_INTRODUCTION_TEMPLATE = "introductionTemplate"
	OPTION_SUBJECT_LINE_LABEL    = "subjectLineLabel"
	OPTION_PUT_DATE_IN_SUBJECT   = "putDateInSubject"
	OPTION_INTRODUCTION          = "introduction"
	OPTION_MAIN_SECTION          = "mainSection"
	OPTION_BODY_SUBSECTIONS      = "bodySubsections"
	OPTION_CONCLUSION            = "conclusion"
	OPTION_POST_MESSAGE          = "postMessage"

	@addresses
	@firstName
	@lastName
	@middleName
	@fullNameOverride
	@introductionTemplate
	@subjectLineLabel
	@putDateInSubject
	@introduction
	@mainSection
	@bodySubsections
	@conclusion
	@postMessage

	def initialize(nippouOptions)
		puts "in constructor"
		pp(nippouOptions)
		@configFilePath = nippouOptions.getConfigFilePath()
		@contentsFilePath = nippouOptions.getContentsFilePath()
		@commandLineOverrides = nippouOptions
		parseConfigFile()
		loadBodyContents(nippouOptions.getContentsFilePath())
	end

	def loadBodyContents(filePath)
		puts "loading main body from #{filePath}"

		# @mainSection = IO.read(filePath, encoding: 'UTF-8')
		@mainSection = IO.read(filePath)
		puts @mainSection
	end

	def parseConfigFile()
		puts "parsing the config file"
		if(!@configFilePath.nil?)
			puts "parsing at path:#{@configFilePath}"
			parseAtPath(@configFilePath)
		elsif(!@configFileName.nil?)
			puts "parsing file with name:#{@configFileName}"
			parseAtPath("./config/user_configs/#{@configFileName}")
		else
			puts 'No config file specified'
		end
	end

	def parseAtPath(completePath)
		parser = FileParser.new()
		data = parser.parse(File.path(completePath));
		# puts data;
		data.each do |key, value|
			puts "key:#{key} value:#{value}"
			filter(key, value)
		end
	end

	def filter(key, value)
		case(key)
		when OPTION_ADDRESSES
			@addresses = value
		when OPTION_FIRST_NAME
			@firstName = @commandLineOverrides.getFirstName() || value
		when OPTION_LAST_NAME
			@lastName = @commandLineOverrides.getLastName() || value
		when OPTION_MIDDLE_NAME
			@middleName = value
		when OPTION_FULL_NAME_OVERRIDE
			@fullNameOverride = value
		when OPTION_INTRODUCTION_TEMPLATE
			@introductionTemplate = value
		when OPTION_SUBJECT_LINE_LABEL
			@subjectLineLabel = value
		when OPTION_PUT_DATE_IN_SUBJECT
			@putDateInSubject = value
		when OPTION_INTRODUCTION
			@introduction = value
		when OPTION_MAIN_SECTION
			@mainSection = value
		when OPTION_BODY_SUBSECTIONS
			@bodySubsections = value
		when OPTION_CONCLUSION
			@conclusion = @commandLineOverrides.getLastMessageFormal() || value
		when OPTION_POST_MESSAGE
			@postMessage = @commandLineOverrides.getLastMessagePersonal() || value
		end
	end

	def getFullName()
		nameParts = [@lastName]
		if(@middleName)
			nameParts.push(@middleName)
		end
		nameParts.push(@firstName)
		return nameParts.join(' ')
	end

	def setDate(newDate = nil)
		if(!newDate.nil?)
			@date = newDate
		end

		@date = DateTime.now
	end

	def getDateFormatted(formatterString = "%Y/%m/%d")
		if(@date.nil?)
			puts 'no date specified, using today'
			setDate()
		end
		return @date.strftime(formatterString);
	end

	def getSubjectLabel()
		return @subjectLabel
	end

	def getFirstName()
		return @firstName
	end

	AddressSeparator = ','
	Newline = "\n"
	IndentNewline = "#{Newline}\t"

	def prepare()
		# @preparedNippou = "recipients:#{indentNewline}#{@emailAddresses.join(' ')}#{newline}subject:#{indentNewline}#{getSubject()}#{newline}body:#{newline}#{buildBody(bodyContents)}"
		puts "build body:" + (buildBody().inspect)
		@preparedNippou = [
			buildRecipients(),
			buildSubject(),
			buildBody(),
			buildConclusion()
		].join(Newline)
	end

	def buildConclusion()
		if(@conclusion.nil?)
			return ''
		end

		return @conclusion + @postMessage
	end

	def buildRecipients()
		if(@addresses.nil?)
			return ''
		end

		return @addresses.join(AddressSeparator)
	end

	def getPreparedNippou()
		return @preparedNippou
	end

	def buildSubject()
		subjectLineElements = [@subjectLineLabel]
		if(@putDateInSubject)
			subjectLineElements.push(getDateFormatted())
		end
		if(@fullNameOverride)
			subjectLineElements.push(@fullNameOverride)
		else
			subjectLineElements.push(getFullName())
		end
		return subjectLineElements.join()
	end

	def makeHeader(firstPart, secondPart = " 特になし")
		return firstPart + secondPart
	end

	def setPostMessage(postMessage)
		@postMessage = postMessage
	end

	def setWorkCodeLine(workCodeLine)
		@workCodeLine = workCodeLine
	end

	def buildBody(bodyContents='')
		namePart = ""
		workCodeLine = @workCodeLine || ""
		firstPartContents = bodyContents
		secondPart = makeHeader("")
		thirdPart = makeHeader("")
		fourthPart = makeHeader("")
		farewell = ""
		postMessage = @postMessage || '';

		bodyContents = [
			namePart,
			workCodeLine,
			firstPartContents,
			secondPart,
			thirdPart,
			fourthPart,
			farewell + postMessage
		]

		separator = "\n\n"

		return bodyContents.join(separator)
	end

	def getFooter()
		return ""
	end

	def output()
		preparedNippou = getPreparedNippou()
		if(preparedNippou.nil?)
			puts 'Need to call prepare nippo method first!'
			return
		end

		puts preparedNippou
	end
end
