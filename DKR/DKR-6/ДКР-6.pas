program DoublyLinkedListStatic;
uses CRT;
const
  MAX = 5;
type
  TNode = record
    data: integer;
    prev: integer;
    next: integer;
    used: boolean;
  end;

var
  nodes: array[1..MAX] of TNode;
  head, tail: integer;

{ Поиск свободной ячейки }
function GetFreeNode: integer;
var
  i: integer;
begin
  for i := 1 to MAX do
    if not nodes[i].used then
    begin
      nodes[i].used := true;
      GetFreeNode := i;
      exit;
    end;
  GetFreeNode := 0;
end;

{ Добавление в конец }
procedure AddToEnd(value: integer);
var
  idx: integer;
begin
  idx := GetFreeNode;
  if idx = 0 then
  begin
    writeln('Нет свободной памяти!');
    exit;
  end;
  nodes[idx].data := value;
  nodes[idx].next := 0;
  nodes[idx].prev := tail;
  if head = 0 then
    head := idx
  else
    nodes[tail].next := idx;
  tail := idx;
end;

{ Удаление элемента }
procedure DeleteValue(value: integer);
var
  i: integer;
begin
  i := head;
  while i <> 0 do
  begin
    if nodes[i].data = value then
    begin
      if nodes[i].prev <> 0 then
        nodes[nodes[i].prev].next := nodes[i].next
      else
        head := nodes[i].next;
      if nodes[i].next <> 0 then
        nodes[nodes[i].next].prev := nodes[i].prev
      else
        tail := nodes[i].prev;
      nodes[i].used := false;
      writeln('Элемент удален');
      exit;
    end;
    i := nodes[i].next;
  end;
  writeln('Элемент не найден');
end;

{ Вывод списка }
procedure PrintList;
var
  i: integer;
begin
  if head = 0 then
  begin
    writeln('Список пуст');
    exit;
  end;
  i := head;
  write('Список: ');
  while i <> 0 do
  begin
    write(nodes[i].data, ' ');
    i := nodes[i].next;
  end;
  writeln;
end;

{ Визуализация структуры }
procedure Visualize;
var
  i: integer;
begin
  writeln('------------------------------------');
  writeln('Index | Data | Prev | Next | Used');
  writeln('------------------------------------');

  for i := 1 to MAX do
    if nodes[i].used then
      writeln(i:5, ' | ', nodes[i].data:4, ' | ',
              nodes[i].prev:4, ' | ',
              nodes[i].next:4, ' | ',
              nodes[i].used);
  writeln('------------------------------------');
end;

{ Инициализация }
procedure Init;
var
  i: integer;
begin
  head := 0;
  tail := 0;
  for i := 1 to MAX do
    nodes[i].used := false;
end;

{ Меню }
procedure Menu;
var
  choice, value: integer;
begin
  repeat
    writeln;
    writeln('===== МЕНЮ =====');
    writeln('1 - Добавить элемент');
    writeln('2 - Удалить элемент');
    writeln('3 - Показать список');
    writeln('4 - Визуализация памяти');
    writeln('0 - Выход');
    write('Ваш выбор: ');
    readln(choice);

    case choice of
      1:
        begin
          write('Введите значение: ');
          readln(value);
          AddToEnd(value);
        end;

      2:
        begin
          write('Введите значение для удаления: ');
          readln(value);
          DeleteValue(value);
        end;

      3: PrintList;

      4: Visualize;
    end;

  until choice = 0;
end;

begin
  Init;
  Menu;
end.