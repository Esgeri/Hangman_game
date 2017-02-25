# Класса, отвечающий за ввод данных в программу "виселица"

class WordReader
  def read_from_args
    ARGV[0]
  end

  def read_from_file(file_name)
    return unless File.exist?(file_name)
    File.readlines(file_name).sample.chomp
  end
end
