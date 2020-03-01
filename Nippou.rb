require 'date'

class Nippou
	def initialize(firstName,lastName,ps = nil)
		@firstName = firstName
		@lastName = lastName
		if(!ps.nil?)
			@ps = ps
		end

		# @subjectLabel = ""

		@emailAddresses = [
		]

		@preparedNippo = nil
	end

	def getFullName()
		return "#{@lastName}・#{@firstName}"
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

	def prepare(bodyContents='')
		newline = "\n"
		indentNewline = "#{newline}\t"
		@preparedNippou = "recipients:#{indentNewline}#{@emailAddresses.join(' ')}#{newline}subject:#{indentNewline}#{getSubject()}#{newline}body:#{newline}#{buildBody(bodyContents)}"
	end

	def getPreparedNippou()
		return @preparedNippou
	end

	def getSubject()
		return "#{getNippouLabel()}#{getDateFormatted()} #{getFullName()}"
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
