enum Modes
  Sub
  Div
end

def corruption_checksum(sheet, mode)
  sheet.lines.map do |line|
    numbers = line.split.map(&.to_i)
    mode.is_a?(Modes::Sub) ? checksum_sub(numbers) : checksum_div(numbers)
  end.sum
end

def checksum_sub(numbers)
  min, max = numbers.minmax
  max - min
end

def checksum_div(numbers)
  numbers.each_combination(2) do |pair|
    smaller, bigger = pair.sort
    return bigger / smaller if bigger.divisible_by?(smaller)
  end
  raise "checksum non-computable"
end

require "spec"

describe "corruption_checksum in substraction mode" do
  it "computes the checksum for single-row spreadsheets" do
    corruption_checksum("5 1 9 5", Modes::Sub).should eq 8
    corruption_checksum("7 5 3", Modes::Sub).should eq 4
    corruption_checksum("2 4 6 8", Modes::Sub).should eq 6
  end

  it "computes the checksum for a multi-row spreadsheet" do
    sheet = <<-SHEET
      5 1 9 5
      7 5 3
      2 4 6 8
      SHEET
    corruption_checksum(sheet, Modes::Sub).should eq 18
  end
end

describe "corruption_checksum in division mode" do
  it "computes the checksum for single-row spreadsheets" do
    corruption_checksum("5 9 2 8", Modes::Div).should eq 4
    corruption_checksum("9 4 7 3", Modes::Div).should eq 3
    corruption_checksum("3 8 6 5", Modes::Div).should eq 2
  end

  it "computes the checksum for a multi-row spreadsheet" do
    sheet = <<-SHEET
      5 9 2 8
      9 4 7 3
      3 8 6 5
      SHEET
    corruption_checksum(sheet, Modes::Div).should eq 9
  end
end
