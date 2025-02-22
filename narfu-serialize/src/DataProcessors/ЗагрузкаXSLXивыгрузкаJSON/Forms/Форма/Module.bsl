&НаКлиенте
Асинх Процедура Загрузка_xlsx(Команда)
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = "Текстовый документ|*.xlsx";
	
	Результат = Ждать ПоместитьФайлНаСерверАсинх(,,, ПараметрыДиалога);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаНаСервере(Результат.Адрес);

КонецПроцедуры

&НаСервере
Процедура ЗагрузкаНаСервере(Адрес)
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяВременногоФайлаxlsx = ПолучитьИмяВременногоФайла("xlsx"); // например был помещен XML
	ДвоичныеДанные.Записать(ИмяВременногоФайлаxlsx);                
	ДанныеДляОбмена.Прочитать(ИмяВременногоФайлаxlsx);
КонецПроцедуры   

&НаКлиенте
Процедура Тест(Команда)
	Редактор.Очистить();
	ГлубХ=0; 
	ГлубУ=0;
		Если ДанныеДляОбмена.Область("R1C1").Текст = "1. Типы номеров" Тогда
			Если ДанныеДляОбмена.Область("R1C2").Текст = "Название" Тогда 
			Сообщить("Вертикальная ориентация");
			ПоОсиХ=0;
			ПоОсиУ=1; 
			ГлубХ=2;
			ИначеЕсли ДанныеДляОбмена.Область("R2C1").Текст = "Название" Тогда
			Сообщить("Горизонтальная ориентация");
			ПоОсиХ=1;
			ПоОсиУ=0;
			ГлубУ=2;
			Иначе
			Сообщить("Не удалось узнать ориентацию таблицы");
			Возврат;	
			КонецЕсли;
				
		Иначе
			Сообщить("Начало таблицы не обнаружено");
			Возврат;
		КонецЕсли; 
		
		Текст = "{";   
		Икс=1;
		Угрик=1;    
		
		Для Счетчик = 1 По 3 Цикл
			Если Не Счетчик = 1 Тогда
			Текст =Текст + ",";	
			КонецЕсли;
			Икс= 1+((Счетчик-1)*5*ПоОсиХ);
			Угрик= 1+((Счетчик-1)*5*ПоОсиУ);   
			Текст =Текст + """" +ДанныеДляОбмена.Область("R"+ Угрик + "C" + Икс ).Текст+ """" + ":";
			Текст =Текст + "[";//Текст =Текст + "[";
			Пункты= Новый Массив(5); 
			Для Счетчик1 = 1 По 5 Цикл
				Если ПоОсиХ=0 Тогда 
					Х=Счетчик1+((Счетчик-1)*5*ПоОсиУ);
			Пункты[Счетчик1-1]=ДанныеДляОбмена.Область("R"+ Х + "C" + 2).Текст;
		Иначе       
			У=Счетчик1+((Счетчик-1)*5*ПоОсиХ);
			 Пункты[Счетчик1-1]=ДанныеДляОбмена.Область("R"+ 2 + "C" + У).Текст;
			 КонецЕсли;
		КонецЦикла;     
		Кол_ВоДанныхВСтроке=0;
		Конец=1;    
		СчётХ=1;
		СчётУ=1;
		Пока Конец=1 Цикл    
			Х=((Счетчик-1)*5*ПоОсиХ)+ГлубХ+СчётХ;
			У=((Счетчик-1)*5*ПоОсиУ)+ГлубУ+СчётУ;
			Если ДанныеДляОбмена.Область("R"+ У + "C" + Х).Текст = "" Тогда
				Если Кол_ВоДанныхВСтроке=0 Тогда
					Кол_ВоДанныхВСтроке=1;
					КонецЕсли;
				Кол_ВоДанныхВСтроке=Кол_ВоДанныхВСтроке*5;
				Конец=0;
			Иначе   
				СчётУ=СчётУ+ПоОсиХ;
				СчётХ=СчётХ+ПоОсиУ;
				Кол_ВоДанныхВСтроке=Кол_ВоДанныхВСтроке+1;
			КонецЕсли;
		КонецЦикла;	
		СтрокаУ=1+ГлубУ;
		СтрокаХ=1+ГлубХ;
		Поз=0;             
		Для Счетчик1 = 1 По Кол_ВоДанныхВСтроке Цикл
			Если Поз=0 Тогда
			Текст =Текст + "{";
			КонецЕсли;
		    Текст =Текст + """" + Пункты[Поз] + """"+":";
			Х=СтрокаХ+((Счетчик-1)*5*ПоОсиХ);
			У=СтрокаУ+((Счетчик-1)*5*ПоОсиУ);
			Текст =Текст + """" +ДанныеДляОбмена.Область("R"+ У + "C" + Х ).Текст+ """";
			Если ПоОсиХ=0 Тогда
				Если СтрокаУ >= 5 Тогда
					Текст =Текст + "}";
				 СтрокаУ=1;
				 СтрокаХ=СтрокаХ+1;
				 Поз=0;     
			 Иначе  
				 Поз=Поз+1;
				 СтрокаУ=СтрокаУ+1;
			 КонецЕсли;
		 Иначе
			 Если СтрокаХ >= 5 Тогда
				 Текст =Текст + "}";
				 СтрокаХ=1;
				 СтрокаУ=СтрокаУ+1;
				 Поз=0;  
			 Иначе 
				 Поз=Поз+1;
				 СтрокаХ=СтрокаХ+1;
			 КонецЕсли;
		 КонецЕсли;  
		 Если Не Счетчик1 = Кол_ВоДанныхВСтроке Тогда
			 Текст =Текст + ",";
			 КонецЕсли
	 КонецЦикла;         
	 Текст =Текст + "]";//Текст =Текст + "]";

		КонецЦикла;
		Текст =Текст + "}";
	    Редактор.ДобавитьСтроку(Текст);

КонецПроцедуры

&НаКлиенте
Процедура Выгрузка(Команда)
		
	Адрес = ВыгрузкаНаСервере();
	
	ПараметрыПолучения = Новый ПараметрыДиалогаПолученияФайлов;
	ПолучитьФайлССервераАсинх(Адрес, "Chtoto.json", ПараметрыПолучения);

КонецПроцедуры

&НаСервере
Функция ВыгрузкаНаСервере()   
	Поток = Новый ПотокВПамяти();
	Редактор.Записать(Поток);
	ДанныеФайла = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	ИмяВременногоФайлаxlsx = ПолучитьИмяВременногоФайла("json");
	ДанныеФайла.Записать(ИмяВременногоФайлаxlsx);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеФайла);
	ДанныеДляОбмена.Очистить();
	Редактор.Очистить();
	Возврат Адрес;
	
КонецФункции 