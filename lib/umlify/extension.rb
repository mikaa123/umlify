# Extends the String to add a String#each method so that
# strings can be read just like files, line-by-line.

class String

  def each

    self.split(/\n/).each do |line|
      yield line
    end

  end
end
