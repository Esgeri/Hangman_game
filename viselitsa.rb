# encoding: utf-8

# Популярная детская игра, версия 3 - с чтением данных из внешних файлов
# https://ru.wikipedia.org/wiki/Виселица_(игра)

# вставляем наши классы, теперь с правильным расположением
# (см. объяснение в исходника и видео прошлого урока)

current_path = "./" + File.dirname(__FILE__)

require current_path + "/game.rb"
require current_path + "/result_printer.rb"
require current_path + "/word_reader.rb"

puts "Игра виселица. Версия 3. C чтением данных из файлов. (c) 2014 Mike Butlitsky\n\n"

# создаем объект, печатающий результаты
printer = ResultPrinter.new

# создаем объект, отвечающий за ввод слова в игру
word_reader = WordReader.new

begin
  # Имя файла, откуда брать слово для загадывания
  words_file_name = current_path + "/data/words.txt"
rescue SystemCallError
  puts 'Не удалось открыть файл words.txt'
end

# создаем объект типа Game, в конструкторе передаем загаданное слово из word_reader-а
game = Game.new(word_reader.read_from_file(words_file_name))

# основной цикл программы, в котором развивается игра
# выходим из цикла, когда объект игры сообщит нам, c пом. метода status
while game.status == 0 do
  # выводим статус игры
  printer.print_status(game)
  # просим угадать следующую букву
  game.ask_next_letter
end

printer.print_status(game)

# Обратите внимание насколько короче, проще и элегантнее стал основной код программы.
# В этом и заключается сила объектно-ориентированного подхода.
