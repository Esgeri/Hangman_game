# Популярная детская игра, версия 4
# https://ru.wikipedia.org/wiki/Виселица_(игра)

require_relative "lib/game.rb"
require_relative "lib/result_printer.rb"
require_relative "lib/word_reader.rb"

VERSION =  "Игра виселица. Версия 4.\n\n"

# создаем объект, отвечающий за ввод слова в игру
word_reader = WordReader.new

begin
  # Имя файла, откуда брать слово для загадывания
  words_file_name = "#{__dir__}/data/words.txt"
rescue SystemCallError
  puts 'Не удалось открыть файл words.txt'
end

word = word_reader.read_from_file(words_file_name)

# создаем объект типа Game, в конструкторе передаем загаданное слово из word_reader-а
game = Game.new(word)  #(word_reader.read_from_file(words_file_name))
game.version = VERSION

# создаем объект, печатающий результаты
printer = ResultPrinter.new(game)

# основной цикл программы, в котором развивается игра
while game.in_progress? do
  # выводим статус игры
  printer.print_status(game)
  # просим угадать следующую букву
  game.ask_next_letter
end

printer.print_status(game)
