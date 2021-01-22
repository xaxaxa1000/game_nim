var
k:array[1..3] of integer;//количество камней в кучках в 10 системе счисления
binary_k:array[1..3] of integer;//количество камней в кучках в 2 системе счисления
copy_binary_k:array[1..3] of integer;//количество камней в кучках в 2 системе счисления
num:array[1..4] of integer;
delete:array[1..3] of integer;
i,game_mode,XOR_,copy_XOR_,count,save,save2,restart:integer;//k(1-3) номера кучек num_1 num_2 числа которые нужны для операции XOR,count кто ходит
ten:integer;
wrong_input,done:boolean;//done флаг который не даёт 2 раза умешить кучи
n:array[1..2] of integer;//номер ячейки которую мы передвинули в пустую когда осталось всего 2 ячейки n[1] откуда n[2] куда
begin 
  restart:=1;
  while restart=1 do
    begin
  writeln('Выберите режим игры:');
  writeln('1.Человек компьютер.');
  writeln('2.Человек человек');
  wrong_input:=true;
  while (wrong_input) do
    begin
  readln(game_mode);
  if(game_mode=1) or (game_mode=2) then 
    begin
    wrong_input:=false;
    end
  else writeln('Неверный ввод!');
  end;
  
  writeln('Введите количество камней в 1 кучке');
  readln(k[1]);
   writeln('Введите количество камней в 2 кучке');
  readln(k[2]);
   writeln('Введите количество камней в 3 кучке');
  readln(k[3]);
  
 
  if(game_mode=1) then
  begin
    count:=1;
    while((k[1]+k[2]+k[3])>1) do//условие того что в 3х кучках есть хотя бы 1 спичка
    begin
      if ((count mod 2)=0) then begin//count-счетчик ходов. если count кратен 2м(0 2 4 6) ходит компьютер
                                     //если count(1,3,5,7) ходит человек
    if(k[1]<>0)and(k[2]<>0)and(k[3]<>0) then//условие того что в 3х кучках есть спички(нету пустой кучки)
      begin
    
    for i:=1 to 3 do
    begin
      ten:=1;
    while k[i]>0 do
    begin
      binary_k[i]:=binary_k[i]+(k[i] mod 2)*ten;
      k[i]:=k[i] div 2;
      ten:=ten*10;
    end;
   end;
 
    XOR_:=0;
    copy_binary_k[1]:=binary_k[1];
    copy_binary_k[2]:=binary_k[2];
    ten:=1;
     while (copy_binary_k[1]>0) or (copy_binary_k[2]>0) do//Нахождение XOR-a для 1 и 2 кучки
     begin
      num[1]:=copy_binary_k[1] mod 10;
      num[2]:=copy_binary_k[2] mod 10;
      XOR_:=XOR_+((num[1] XOR num[2])*ten);
      ten:=ten*10;
      copy_binary_k[1]:=copy_binary_k[1] div 10;
      copy_binary_k[2]:=copy_binary_k[2] div 10;
     end;
    
     ten:=1;
     copy_XOR_:=XOR_;
     XOR_:=0;
     copy_binary_k[3]:=binary_k[3];
     while (copy_XOR_>0) or (copy_binary_k[3]>0) do // Нахождение XOR-a (1 и 2 кучки) с 3 кучкой
     begin
      num[4]:=copy_XOR_ mod 10;
      num[3]:=copy_binary_k[3] mod 10;
      XOR_:=XOR_+((num[4] XOR num[3])*ten);
      ten:=ten*10;
      copy_XOR_:=copy_XOR_ div 10;
      copy_binary_k[3]:=copy_binary_k[3] div 10;
     end;
   
    if(XOR_<>0) then//XOR <> 0
    begin  
    done:=false;
      delete[1]:=0;
      delete[2]:=0;
      delete[3]:=0;
    for i:=1 to 3 do
    begin
      copy_XOR_:=XOR_;
      copy_binary_k[i]:=binary_k[i];
      ten:=1;
      while (copy_XOR_>0) or (copy_binary_k[i]>0) do // повторный XOR
     begin
      num[4]:=copy_XOR_ mod 10;
      num[i]:=copy_binary_k[i] mod 10;
      delete[i]:=delete[i]+((num[4] XOR num[i])*ten);
      ten:=ten*10;
      copy_XOR_:=copy_XOR_ div 10;
      copy_binary_k[i]:=copy_binary_k[i] div 10;
     end;
     
     if(delete[i]<binary_k[i]) and not done then
     begin
       save:=binary_k[i];
       save2:=i;
       binary_k[i]:=delete[i];
       done:=true;
       end;
    end;
  
    for i:=1 to 3 do//перевод всех 3 чисел в 10 систему счисления
    begin
    num[1]:=1;
    while binary_k[i]>0 do
    begin
      k[i]:=k[i]+(num[1]*(binary_k[i] mod 10));
      num[1]:=num[1]*2;
      binary_k[i]:=binary_k[i] div 10;
    end;
    end;
    num[3]:=0;
   num[1]:=1;
    while save>0 do
    begin
     num[3]:=num[3]+(num[1]*(save mod 10));
      num[1]:=num[1]*2;
      save:=save div 10;
    end;
    
    
    writeln('Компьютер убирает из ',save2,' кучки ',num[3]-k[save2],' спичек');
    writeln('Текущая позиция ',k);
    end
    else//если XOR_=0 убираем все спички из не нулевой кучи так как позиция всё равно проигрышная и ход ничего не решает
    begin
      done:=false;
      for i:=1 to 3 do 
      begin
        if (binary_k[i] <> 0) and not done then
        begin
          save:=binary_k[i];
          save2:=i;
          done:=true;
          binary_k[i]:=0;
        end;
      end;
       for i:=1 to 3 do//перевод всех 3 чисел в 10 систему счисления
    begin
    num[1]:=1;
    while binary_k[i]>0 do
    begin
      k[i]:=k[i]+(num[1]*(binary_k[i] mod 10));
      num[1]:=num[1]*2;
      binary_k[i]:=binary_k[i] div 10;
    end;
    end;
    num[1]:=1;
    num[4]:=0;
    while save>0 do
    begin
      num[4]:=num[4]+(num[1]*(save mod 10));
      num[1]:=num[1]*2;
      save:=save div 10;
    end;
    writeln('Компьютер убирает из ',save2,' кучки ',num[4],' спичек');
      writeln('Текущая позиция ',k);
    end;
    count:=count+1;
  end
  else
  begin
    
    if(k[1]<>k[2])and(k[1]<>k[3])and(k[2]<>k[3]) then
     begin
   if(k[1]=0) then 
   begin
     k[1]:=k[3];
     n[1]:=3;
     n[2]:=1;
     save:=1;
     end;
    if(k[2]=0) then 
   begin
     k[2]:=k[3];
     n[1]:=3;
     n[2]:=2;
     save:=2;
     end;
     if(k[3]=0) then 
   begin
     n[1]:=0;
     n[2]:=0;
     save:=3;
     end;
     
       if(k[1]>k[2]) then
         begin
         num[1]:=k[1]-k[2];
         k[1]:=k[1]-num[1];
         save2:=1;
         end;
         if(k[1]<k[2]) then
            begin
            num[1]:=k[2]-k[1];
            k[2]:=k[2]-num[1];
            save2:=2;
            end;
           if(n[1]=3) and (n[2]=1) then
              begin
              k[3]:=k[1];
              k[1]:=0;
              end;
            if(n[1]=3) and (n[2]=2) then
              begin
              k[3]:=k[2];
              k[2]:=0;
              end;
              if(save=1)and(save2=1) then  writeln('Компьютер убирает из 3 кучки ',num[1],' спичек');
              if(save=1)and(save2=2) then  writeln('Компьютер убирает из 2 кучки ',num[1],' спичек');
              if(save=2)and(save2=1) then  writeln('Компьютер убирает из 1 кучки ',num[1],' спичек');
              if(save=2)and(save2=2) then  writeln('Компьютер убирает из 3 кучки ',num[1],' спичек');
              if(save=3)and(save2=1) then  writeln('Компьютер убирает из 1 кучки ',num[1],' спичек');
              if(save=3)and(save2=2) then  writeln('Компьютер убирает из 2 кучки ',num[1],' спичек');
          writeln('Текущая позиция',k);      
     end
     else
     begin
    if (k[1]<>0)and((k[2]+k[3])=0) or (k[2]<>0)and((k[1]+k[3])=0) or (k[3]<>0)and((k[2]+k[1])=0) then
    begin
      if(k[1]<>0) then
      begin
        num[1]:=k[1];
        k[1]:=0;
        writeln('Компьютер убирает из 1 кучки ',num[1],' спичек');
      end;
      if(k[2]<>0) then
      begin 
        num[1]:=k[1];
        k[2]:=0;
        writeln('Компьютер убирает из 2 кучки ',num[1],' спичек');
      end;
      if(k[3]<>0) then
      begin
        num[1]:=k[1];
        k[3]:=0;
         writeln('Компьютер убирает из 3 кучки ',num[1],' спичек');
      end;
      writeln('Текущая позиция',k);
    end 
    else
      begin    
     done:=false;
      for i:=1 to 3 do 
      begin
        if (k[i] <> 0) and (done=false) then
        begin
          done:=true;
          writeln('Компьютер убирает из ',i,' кучки 1 спичку');
          k[i]:=k[i]-1;
        end;
      end;
     writeln('Текущая позиция',k);
     end;
     end;
     count:=count+1;
    end;
    end 
    else
    begin
      wrong_input:=true;
      writeln('Ведите номер кучки из которой хотите убрать спички');
      while wrong_input do
        begin
      readln(num[1]);
      if(num[1]>=1) and (num[1]<=3)and(k[num[1]]<>0) then 
        begin
        wrong_input:=false;
        end
        else
           writeln('Неверный ввод');
      end;
      wrong_input:=true;
      writeln('Введите количество спичек которые хотите убрать');
      while wrong_input do
        begin
      readln(num[2]);
      if((num[2]>0) and ((k[num[1]]-num[2])>=0))  then
      begin
        wrong_input:=false;
        end
        else
          writeln('Неверный ввод');
      end;
      k[num[1]]:=k[num[1]]-num[2];
       count:=count+1;
       writeln('Вы убираете из ',num[1],' кучки ',num[2],' спичек');
       writeln('Текущая позиция ',k);
       end;
  end;
 end;
 if(game_mode=2) then
 begin
   count:=1;
   while(k[1]+k[2]+k[3]>1) do
     begin
   if((count mod 2)=1) then 
   begin
     wrong_input:=true;
      writeln('Игрок 1. Ведите номер кучки из которой хотите убрать спички');
      while wrong_input do
        begin
      readln(num[1]);
      if(num[1]>=1) and (num[1]<=3)and(k[num[1]]<>0) then 
        begin
        wrong_input:=false;
        end
        else
           writeln('Неверный ввод');
      end;
          wrong_input:=true;
      writeln('Игрок 1. Введите количество спичек которые хотите убрать');
      while wrong_input do
        begin
      readln(num[2]);
      if(num[2]>0) and ((k[num[1]]-num[2])>=0) then
      begin
        wrong_input:=false;
        end
        else
          writeln('Неверный ввод');
      end;
      k[num[1]]:=k[num[1]]-num[2];
       count:=count+1;
       writeln('Игрок 1 убирает из ',num[1],' кучки ',num[2],' спичек');
       writeln('Текущая позиция ',k);
     //игрок 1
   end
   else
   begin
      wrong_input:=true;
      writeln('Игрок 2. Ведите номер кучки из которой хотите убрать спички');
      while wrong_input do
        begin
      readln(num[1]);
      if(num[1]>=1) and (num[1]<=3)and(k[num[1]]<>0) then 
        begin
        wrong_input:=false;
        end
        else
           writeln('Неверный ввод');
      end;
          wrong_input:=true;
      writeln('Игрок 2. Введите количество спичек которые хотите убрать');
      while wrong_input do
        begin
      readln(num[2]);
      if(num[2]>0) and ((k[num[1]]-num[2])>=0) then
      begin
        wrong_input:=false;
        end
        else
          writeln('Неверный ввод');
      end;
      k[num[1]]:=k[num[1]]-num[2];
       count:=count+1;
       writeln('Игрок 2 убирает из ',num[1],' кучки ',num[2],' спичек');
       writeln('Текущая позиция ',k);
   end;
 end;
 end;
 writeln('1.Перезапустить');
 writeln('2.Закочить');
 readln(restart);
 end
end.