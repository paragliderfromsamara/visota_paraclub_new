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
end