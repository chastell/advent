def cycle_count(memory)
  banks = memory.split.map(&.to_i)
  round(banks)[:size]
end

def loop_size(memory)
  banks = memory.split.map(&.to_i)
  looper = round(banks)[:looper]
  round(looper)[:size]
end

private def cycle(banks)
  max = banks.max
  pos = banks.index(max).not_nil!
  banks[pos] = 0
  max.times { |offset| banks[(pos + 1 + offset) % banks.size] += 1 }
  banks
end

private def round(banks)
  seen = Set(typeof(banks)).new
  until seen.includes?(banks)
    seen << banks
    banks = cycle(banks.dup)
  end
  {size: seen.size, looper: banks}
end

require "spec"

describe "cycle_count" do
  it "counts the number of memory reallocation cycles" do
    cycle_count("0 2 7 0").should eq 5
  end
end

describe "loop_size" do
  it "counts the loop size between subsequent repetitions" do
    loop_size("0 2 7 0").should eq 4
  end
end
