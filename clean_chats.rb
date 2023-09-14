files = Dir.glob("*.txt")

files.each do |file|
  # Replace regex with empty string
  ftext = File.read(file).gsub(/(>.*:\n)/, "")
  File.write(file, ftext)
end
