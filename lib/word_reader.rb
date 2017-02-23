# Класса, отвечающий за ввод данных в программу "виселица"

class WordReader
  def read_from_args
    ARGV[0]
  end

  def read_from_file(file_name)
    begin
      file = File.new(file_name, "r:UTF-8")
      lines = file.readlines
    rescue SystemCallError => e
      e.message
      abort "Не удалось открыть файл #{file_name}"
    end
    file.close

    lines.sample.chomp
  end
end
