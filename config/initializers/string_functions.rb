class String
  def escapeBbCode
    text = self
    regExArr = [
                /#Photo(\d+)/,
                /#Theme(\d+)(\[(.+)\])?/,
                /#User(\d+)(\[(.+)\])?/,
                "[quote]",
                "[/quote]",
                "[align-center]",
                "[/align-center]",
                '[align-right]',
                '[/align-right]'
               ]
    regExArr.each do |a|
      text = text.gsub(a, "")
    end
    return text    
  end
  def getIdsArray
    str = self
  	ids = []
  	id = ''
  	str.chars do |ch|
  		if ch != '[' and ch != ']'
  			id += ch
  		elsif ch == ']'
  			ids[ids.length] = id
  			id = ''
  		end
  	end
  	return ids
  end
end