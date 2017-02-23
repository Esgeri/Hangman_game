# encoding: utf-8

# Основной класс игры. Хранит состояние игры и предоставляет функции
# для развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.)
#
# За основу взяты методы из первой версии этой игры (подробные комментарии смотрите в прошлых
# уроках).

require "unicode_utils/upcase"

class Game
  # Сокращенный способ записать сеттеры для получения информации об игре
  attr_reader :errors, :letters, :good_letters, :bad_letters, :status
  attr_accessor :version

  # Константа с максимальным количеством ошибок
  MAX_ERRORS = 7

  # конструктор - вызывается всегда при создании объекта данного класса
  # имеет один параметр, в него нужно передавать при создании загаданное слово
  def initialize(letter)
    # инициализируем данные как поля класса
    @letters = get_letters(letter)

    # переменная-индикатор кол-ва ошибок, всего можно сделать не более 7 ошибок
    @errors = 0

    # массивы, хранящие угаданные и неугаданные буквы
    @good_letters = []
    @bad_letters = []

    # В поле @status теперь будет лежать не бездушная цифра
    # А символ, который наглядно показывает статус
    @status = :in_progress # :won, :lost
  end

  # Метод, который возвращает массив букв загаданного слова
  def get_letters(letter)
    if (letter == nil || letter == "")
      abort "Задано пустое слово, не о чем играть. Закрываемся."
    else
      letter = UnicodeUtils.upcase(letter).encode("UTF-8")
    end

    return letter.split("")
  end

  # Метод, который просто возвращает константу MAX_ERRORS
  def max_errors
    MAX_ERRORS
  end

  # Метод, который возвращает количество оставшихся ошибок
  def errors_left
    MAX_ERRORS - @errors
  end

  # Метод, который отвечает на вопрос, является ли буква подходящей
  def is_good?(letter)
    @letters.include?(letter) ||
      (letter == "Е" && @letters.include?("Ё")) ||
      (letter == "Ё" && @letters.include?("Е")) ||
      (letter == "И" && @letters.include?("Й")) ||
      (letter == "Й" && @letters.include?("И"))
  end

  # Метод добавляет букву к массиву (хороших или плохих букв)
  def add_letter_to(letters, letter)
    # Обратите внимание, что переменная - это только ярлык,
    # не смотря на то, что letters после работы метода исчезнет,
    # объект, который мы поменяли, останется
    letters << letter

    case letter
    when 'И' then letters << 'Й'
    when 'Й' then letters << 'И'
    when 'Е' then letters << 'Ё'
    when 'Ё' then letters << 'Е'
    end
  end

  # Метод, который отвечает на вопрос, отгадано ли все слово
  def solved?
    (@letters - @good_letters).empty?
  end

  # Метод, который отвечает на вопрос, была ли уже эта буква
  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  # Метод, который отвечает на вопрос, проиграна ли игра
  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end

  # Метод, который отвечает на вопрос, продолжается ли игра
  def in_progress?
    @status == :in_progress
  end

  # Метод, который отвечает на вопрос, выиграл ли игрок
  def won?
    @status == :won
  end

# Старый метод, который продвигает состояние игры на следующий ход
  def next_step(letter)
    # Поднимаем букву в верхний регистр
    letter = UnicodeUtils.upcase(letter)

    # Вываливаемся, если игра уже закончена
    return if @status == :lost || @status == :won

    # Вываливаемся, если буква уже была
    return if repeated?(letter)

    if is_good?(letter)
      # Если буква подошла, добавляем её к хорошим
      add_letter_to(@good_letters, letter)

      # Если слово отгадано, меняем статус
      @status = :won if solved?
    else
      # Если буква не подошла, добавляем к плохим
      add_letter_to(@bad_letters, letter)

      # Увеличиваем количество ошибок
      @errors += 1

      # Меняем статус на проигрыш, если игра проиграна
      @status = :lost if lost?
    end
  end

  # Метод, спрашивающий юзера букву и возвращающий ее как результат.
  # В идеале этот метод лучше вынести в другой класс, потому что он относится не только
  # к состоянию игры, но и к вводу данных.
  def ask_next_letter
    puts "\nВведите следующую букву"
    letter = ""
    while letter == "" do
      letter = UnicodeUtils.upcase(STDIN.gets).encode("UTF-8").chomp
    end
    # после получения ввода, передаем управление в основной метод игры
    next_step(letter)
  end


# Методы, так называемые accessors - смысл каждого метода - только предоставить
# внутренние поля класса. Без таких методов к полям @letters, @errors и т. п.
# нет доступа ни у кого, кроме самого объекта данного класса

# ----------------------------------------------------------------------
  def errors
    @errors # ВАЖНАЯ фишка Ruby, слово return можно опустить, если это последняя строка в методе
  end

  def letters
    @letters
  end

  def good_letters
    @good_letters
  end

  def bad_letters
    @bad_letters
  end
end
