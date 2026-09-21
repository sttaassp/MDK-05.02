uses CRT;

// Компараторы
function ПоВозрастанию(a, b: integer): boolean; 
begin
  result := a < b;
end;

function ПоУбыванию(a, b: integer): boolean; 
begin
  result := a > b;
end;

// Сортировка вставками (Insertion Sort)
procedure СортировкаВставками(var arr: array of integer; cm: function(x, y: integer): boolean);
var
  i, j, key: integer;
begin
  for i := 1 to High(arr) do
  begin
    key := arr[i];
    j := i - 1;
    
    // Сдвигаем элементы, которые больше (или меньше) ключа
    while (j >= 0) and cm(key, arr[j]) do
    begin
      arr[j + 1] := arr[j];
      j := j - 1;
    end;
    
    arr[j + 1] := key;
  end;
end;

// Быстрая сортировка (Quick Sort) - рекурсивная часть
procedure БыстраяСортировка(var arr: array of integer; left, right: integer; cm: function(x, y: integer): boolean);
var
  i, j, pivot, temp: integer;
begin
  if left < right then
  begin
    i := left;
    j := right;
    pivot := arr[(left + right) div 2]; // Опорный элемент
    
    repeat
      // Ищем элементы, которые нужно поменять местами
      while cm(arr[i], pivot) do
        i := i + 1;
      
      while cm(pivot, arr[j]) do
        j := j - 1;
      
      if i <= j then
      begin
        // Обмен элементов
        temp := arr[i];
        arr[i] := arr[j];
        arr[j] := temp;
        i := i + 1;
        j := j - 1;
      end;
    until i > j;
    
    // Рекурсивно сортируем подмассивы
    if left < j then
      БыстраяСортировка(arr, left, j, cm);
    if i < right then
      БыстраяСортировка(arr, i, right, cm);
  end;
end;

// Обертка для быстрой сортировки
procedure БыстраяДоп(var arr: array of integer; cm: function(x, y: integer): boolean);
begin
  if Length(arr) > 0 then
    БыстраяСортировка(arr, 0, High(arr), cm);
end;

// Функция для парсинга строки с числами
function ParseNumbers(input: string): array of integer;
var
  numbers: array of integer;
  temp: string;
  i, pos, num, count: integer;
begin
  if Trim(input) = '' then
  begin
    Result := nil;
    Exit;
  end;
  
  // Заменяем запятые на пробелы
  temp := input;
  for i := 1 to Length(temp) do
    if temp[i] = ',' then temp[i] := ' ';
  
  // Считаем количество чисел
  count := 0;
  i := 1;
  while i <= Length(temp) do
  begin
    // Пропускаем пробелы
    while (i <= Length(temp)) and (temp[i] = ' ') do
      i := i + 1;
    
    if i <= Length(temp) then
    begin
      // Нашли начало числа
      count := count + 1;
      // Пропускаем число
      while (i <= Length(temp)) and (temp[i] <> ' ') do
        i := i + 1;
    end;
  end;
  
  if count = 0 then
  begin
    Result := nil;
    Exit;
  end;
  
  SetLength(numbers, count);
  count := 0;
  i := 1;
  
  while i <= Length(temp) do
  begin
    // Пропускаем пробелы
    while (i <= Length(temp)) and (temp[i] = ' ') do
      i := i + 1;
    
    if i <= Length(temp) then
    begin
      // Находим конец числа
      pos := i;
      while (pos <= Length(temp)) and (temp[pos] <> ' ') do
        pos := pos + 1;
      
      // Извлекаем подстроку с числом
      if TryStrToInt(Copy(temp, i, pos - i), num) then
      begin
        numbers[count] := num;
        count := count + 1;
      end;
      
      i := pos;
    end;
  end;
  
  // Обрезаем массив до фактического размера
  SetLength(numbers, count);
  Result := numbers;
end;

// Функция для чтения чисел из файла
function ReadFromFile(filename: string): array of integer;
var
  f: text;
  line: string;
  numbers: array of integer;
  tempNumbers: array of integer;
  i, j: integer;
begin
  if not FileExists(filename) then
  begin
    Result := nil;
    Exit;
  end;
  
  assign(f, filename);
  reset(f);
  
  SetLength(numbers, 0);
  
  while not eof(f) do
  begin
    readln(f, line);
    line := Trim(line);
    
    if line <> '' then
    begin
      tempNumbers := ParseNumbers(line);
      
      if tempNumbers <> nil then
      begin
        // Добавляем числа из текущей строки к общему массиву
        j := Length(numbers);
        SetLength(numbers, j + Length(tempNumbers));
        for i := 0 to Length(tempNumbers) - 1 do
          numbers[j + i] := tempNumbers[i];
      end;
    end;
  end;
  
  close(f);
  Result := numbers;
end;

// основная программа
var
  arr: array of integer; 
  cmp: function(x, y: integer): boolean; 
  s, c, i: integer; 
  inf, outf: string; 
  f: text;
begin
  // Пути к файлам
  inf := 'input.txt';
  outf := 'output.txt';

  ClrScr;
  writeln('Исследование алгоритмов сортировки');
  writeln;
  
  // 1. СНАЧАЛА ЧИТАЕМ ДАННЫЕ ИЗ ФАЙЛА!
  if not FileExists(inf) then
  begin
    writeln('Ошибка: Файл ', inf, ' не найден!');
    writeln('Создайте файл input.txt с числами');
    writeln('Нажмите любую клавишу для выхода...');
    ReadKey;
    Exit;
  end;
  
  arr := ReadFromFile(inf);
  
  if (arr = nil) or (Length(arr) = 0) then
  begin
    writeln('Ошибка: Файл пуст или не содержит чисел!');
    writeln('Нажмите любую клавишу для выхода...');
    ReadKey;
    Exit;
  end;
  // 2. ВЫБИРАЕМ СОРТИРОВКУ
  writeln('Выберите тип сортировки:');
  writeln('1. Сортировка вставками');
  writeln('2. Быстрая сортировка');
  write('Выбор: ');
  readln(s);

  writeln;
  writeln('Выберите компаратор:');
  writeln('1. По возрастанию');
  writeln('2. По убыванию');
  write('Выбор: ');
  readln(c);
  writeln;

  if c = 1 then cmp := ПоВозрастанию
  else cmp := ПоУбыванию;
 
  
  // 4. ВЫПОЛНЯЕМ СОРТИРОВКУ
  case s of
    1: 
      begin
        writeln('Выполняется сортировка вставками...');
        СортировкаВставками(arr, cmp);
      end;
    2: 
      begin
        writeln('Выполняется быстрая сортировка...');
        БыстраяДоп(arr, cmp);
      end;
    else
      begin
        writeln('Неверный выбор сортировки');
        Halt;
      end;
  end;
 
  // 6. ЗАПИСЫВАЕМ РЕЗУЛЬТАТ В ФАЙЛ
  assign(f, outf);
  rewrite(f);
  
  // Записываем все числа в одну строку через пробел
  for i := 0 to High(arr) do
  begin
    write(f, arr[i]);
    if i < High(arr) then
      write(f, ' '); // Добавляем пробел между числами, но не после последнего
  end;
  writeln(f); // Переход на новую строку в конце
  
  close(f);
  writeln;
  writeln('Результат записан в файл: ', outf);
  writeln;
  ReadKey;
end.