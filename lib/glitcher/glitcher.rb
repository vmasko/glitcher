require 'rmagick'
include Magick

class Glitcher
  attr_accessor :image, :output, :pixels

  def initialize(file)
    @image  = Image.read(file)[0]
    @pixels = image.export_pixels
    @output = []
  end

  def shuffle(first, last, size)
    selection = pixels[first..last]
    selection.each_slice(size) do |slice|
      @output << slice
    end
    pixels[first..last] = output.shuffle.flatten
  end

  def save(x, y, cols, rows)
    result = image.import_pixels(x, y, cols, rows, 'RGB', pixels)
    check_folder
    result.write("#{file_name}")
  end

  def check_folder
    Dir.mkdir('output') unless Dir.glob('*').include?('output')
  end

  def file_name
    "output/glitched_output_#{number}.jpg"
  end

  def number
    file = Dir.glob('output/*').last
    return file[/\d/].to_i + 1 unless file.nil?
    1
  end
end
