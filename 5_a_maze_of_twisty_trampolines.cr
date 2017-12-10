def maze_steps(maze)
  instructions = maze.split.map(&.to_i)
  position = 0
  count = 0
  while position < instructions.size
    count += 1
    jump = instructions[position]
    jump >= 3 ? (instructions[position] -= 1) : (instructions[position] += 1)
    position += jump
  end
  count
end

require "spec"

describe "maze_steps" do
  it "returns the number of steps needed to exit the maze" do
    maze_steps("0 3 0 1 -3").should eq 10
  end
end
