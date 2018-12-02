enum Match
  Next
  Halfway
end

def inverse_captcha(number, match)
  digits = number.split("").map(&.to_i)
  rotation = match.is_a?(Match::Halfway) ? digits.size / 2 : 1
  matches = digits.zip(digits.rotate(rotation)).select { |(a, b)| a == b }
  matches.map(&.first).sum
end

require "spec"

describe "inverse_captcha matching on next digit" do
  it "sums digits followed by themselves" do
    inverse_captcha("1122", Match::Next).should eq 3
  end

  it "considers each digit separately" do
    inverse_captcha("1111", Match::Next).should eq 4
  end

  it "returns 0 if none digit matches next" do
    inverse_captcha("1234", Match::Next).should eq 0
  end

  it "matches last with first" do
    inverse_captcha("91212129", Match::Next).should eq 9
  end
end

describe "inverse_captcha matching on a digit halfway away" do
  it "sums digits followed halfway-through by themselves" do
    inverse_captcha("1212", Match::Halfway).should eq 6
  end

  it "returns 0 if none digit matches the one halfway through" do
    inverse_captcha("1221", Match::Halfway).should eq 0
  end

  it "matches digits halfway around" do
    inverse_captcha("123425", Match::Halfway).should eq 4
  end

  it "matches other provided examples" do
    inverse_captcha("123123", Match::Halfway).should eq 12
    inverse_captcha("12131415", Match::Halfway).should eq 4
  end
end
