def valid?(passphrase)
  words = passphrase.split
  words.size == words.map(&.chars.sort).uniq.size
end

def valid_count(passphrases)
  passphrases.lines.count { |passphrase| valid?(passphrase) }
end

require "spec"

describe "valid?" do
  it "validates passphrases by word uniqueness" do
    valid?("aa bb cc dd ee").should eq true
    valid?("aa bb cc dd aa").should eq false
    valid?("aa bb cc dd aaa").should eq true
  end

  it "validates passphrases by anagram uniqueness" do
    valid?("abcde fghij").should eq true
    valid?("abcde xyz ecdab").should eq false
    valid?("a ab abc abd abf abj").should eq true
    valid?("iiii oiii ooii oooi oooo").should eq true
    valid?("oiii ioii iioi iiio").should eq false
  end
end

describe "valid_count" do
  it "counts valid passphrases" do
    list = <<-END
      aa bb cc dd ee
      aa bb cc dd aa
      aa bb cc dd aaa
      END
    valid_count(list).should eq 2
  end
end
