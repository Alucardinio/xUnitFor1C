﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;

&НаКлиенте
Перем ТестируемаяФорма;

// { интерфейс тестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПарам) Экспорт
	
	ОписанияТестов = Новый Массив;
	
	НужноИсключениеЕслиНеНайденоДокументов = Ложь;

	ПутьНастройки = "1smoke.json";
	НачальнаяНастройка(КонтекстЯдраПарам, ПутьНастройки);
	
	//НаборТестов.СтрогийПорядокВыполнения();
	
	СоздатьИменаОсновныхФорм();
	
	ТолькоУправляемыеФормы = Истина;
	//#Если ТонкийКлиент или ВебКлиент Тогда
	#Если ТолстыйКлиентОбычноеПриложение или ТолстыйКлиентУправляемоеПриложение  Тогда
		ТолькоУправляемыеФормы = Ложь;
	#КонецЕсли
	
	Если Не ИспользоватьОбычныеФормыВТолстомКлиентеВУправляемомРежимеСервер() Тогда
		ТолькоУправляемыеФормы = Истина;
	КонецЕсли;
		
	Объект.ВыводитьСообщенияВЖурналРегистрации = Истина;
	
	ИменаОсновныхФорм_Объекты_Сервер = ИменаОсновныхФорм_Объекты_Сервер();
	мИменаОсновныхФорм_Списки_Сервер = мИменаОсновныхФорм_Списки_Сервер();
	
	ДобавитьТестыДляСправочниковСервер(ОписанияТестов, ТолькоУправляемыеФормы, ИменаОсновныхФорм_Объекты_Сервер, мИменаОсновныхФорм_Списки_Сервер);
	ДобавитьТестыДляДокументовСервер(ОписанияТестов, ТолькоУправляемыеФормы, ИменаОсновныхФорм_Объекты_Сервер, мИменаОсновныхФорм_Списки_Сервер);
	
	ДобавитьТестыДляОтчетовОбработокСервер(ОписанияТестов, ТолькоУправляемыеФормы);

	ОписанияТестов.Добавить("ТестДолжен_ПроверитьБагПлатформыПриОткрытииУправляемойФормыПриОткрытииКоторойЕстьИсключение");
	
	ДобавитьОписанияТестовВНаборТестов(НаборТестов, ОписанияТестов);
КонецПроцедуры

// } интерфейс тестирования

//{ блок юнит-тестов - САМИ ТЕСТЫ

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт
	//Предупреждение("Спец.окно для для показа сообщений из тестов. Таймаут 1 секунда",1); // нужно для показа сообщений из теста, иначе не будут показаны
	
	ВыводитьСообщенияВЖурналРегистрации = Истина;
	Объект.ВыводитьСообщенияВЖурналРегистрации = Истина;
	
	CоздаваемыйЭлемент = Неопределено;
	
	ОбновитьПовторноИспользуемыеЗначения();

	НужноИсключениеЕслиНеНайденоДокументов = Ложь;

	СоздатьИменаОсновныхФорм();
	
	//НачатьТранзакциюСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
	//ОтменитьТранзакциюСервер();
	
	ЗакрытьФорму();
	УдалитьСозданныйОбъект();
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПропуститьТестФормы(Знач ПричинаПропускаТеста) Экспорт
	КонтекстЯдра.ПропуститьТест(ПричинаПропускаТеста);
КонецПроцедуры

&НаСервере
Процедура УдалитьСозданныйОбъект()
	Если ЗначениеЗаполнено(CоздаваемыйЭлемент) Тогда
		CозданныйОбъект = CоздаваемыйЭлемент.ПолучитьОбъект();
		CозданныйОбъект.Удалить();
	КонецЕсли;
	CоздаваемыйЭлемент = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	//Если ТипЗнч(ТестируемаяФорма) <> Тип("Форма") и ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
	Если ТипЗнч(ТестируемаяФорма) <> Тип("УправляемаяФорма") Тогда
		Возврат;
	КонецЕсли; 
	ТестируемаяФорма.Модифицированность = Ложь;
	Если ТестируемаяФорма.Открыта() Тогда
		ТестируемаяФорма.Модифицированность = Ложь;
		//Попытка
			ТестируемаяФорма.Закрыть();
		//Исключение
		//	Ошибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		//	ЗакрытьФормуБезусловноСОтменойТранзакции(ТестируемаяФорма);
		//	//Если ТранзакцияАктивна() Тогда
		//	//	ОтменитьТранзакцию();
		//	//КонецЕсли;
		//	//	//ДобавитьСтрокуРезультата(ИмяОперации, ИнформацияОбОшибке());
		//	//НачатьТранзакцию();
		//	//ТестируемаяФорма.УстановитьДействие("ПередЗакрытием", Неопределено);
		//	//ТестируемаяФорма.УстановитьДействие("ПриЗакрытии", Неопределено);
		//	//ТестируемаяФорма.Закрыть();
		//	ВызватьИсключение Ошибка; 			
		//КонецПопытки;
	Иначе
		Попытка
			ТестируемаяФорма.Закрыть();
		Исключение
		КонецПопытки;
	КонецЕсли;
	ТестируемаяФорма = "";

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОписанияТестовВНаборТестов(НаборТестов, ОписанияТестов)
	Для Каждого Описание Из ОписанияТестов Цикл
		Если ТипЗнч(Описание) = Тип("Строка") Тогда
			НаборТестов.Добавить(Описание);
		Иначе
			НаборТестов.Добавить(Описание.ИмяТеста, НаборТестов.ПараметрыТеста(Описание.Параметр), Описание.ПредставлениеТеста);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ДобавитьТестыДляСправочниковСервер(ОписанияТестов, ТолькоУправляемыеФормы, ИменаОсновныхФорм_Объекты_Сервер, мИменаОсновныхФорм_Списки_Сервер)
	ОсновнойОбъект = Объект();
	СписокИсключений_Существующие = ОсновнойОбъект.ПолучитьСписокИсключений_Справочники_Существующие();
	СписокИсключений_Новые = ОсновнойОбъект.ПолучитьСписокИсключений_Справочники_Новые();
	СписокИсключений_Списки = ОсновнойОбъект.ПолучитьСписокИсключений_Справочники_Списки();
	
	менеджерМетаданного = Метаданные.Справочники;
	Для Каждого МетаОбъект Из менеджерМетаданного Цикл
		
		Если ПравоДоступа("ИнтерактивноеДобавление", МетаОбъект) Тогда
			имяТеста = "ТестДолжен_ОткрытьФормуНовогоЭлементаСправочника";
			ПрефиксПредставленияТеста = "Новые";
			СписокИсключений = СписокИсключений_Новые;
			ИменаОсновныхФорм = ИменаОсновныхФорм_Объекты_Сервер;
			
			ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
		КонецЕсли;		
		
		имяТеста = "ТестДолжен_ОткрытьФормуСуществующегоЭлементаСправочника";
		ПрефиксПредставленияТеста = "Существующие";
		СписокИсключений = СписокИсключений_Существующие;
		ИменаОсновныхФорм = ИменаОсновныхФорм_Объекты_Сервер;
		
		ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);

		имяТеста = "ТестДолжен_ОткрытьФормуПоПолномуИмениФормы";
		ПрефиксПредставленияТеста = "Списки";
		СписокИсключений = СписокИсключений_Списки;
		ИменаОсновныхФорм = мИменаОсновныхФорм_Списки_Сервер;
		
		ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
	КонецЦикла;
КонецФункции

&НаСервере
Функция ДобавитьТестыДляДокументовСервер(ОписанияТестов, ТолькоУправляемыеФормы, ИменаОсновныхФорм_Объекты_Сервер, мИменаОсновныхФорм_Списки_Сервер)
	ОсновнойОбъект = Объект();
	СписокИсключений_Существующие = ОсновнойОбъект.ПолучитьСписокИсключений_Документы_Существующие();
	СписокИсключений_Новые = ОсновнойОбъект.ПолучитьСписокИсключений_Документы_Новые();
	СписокИсключений_Списки = ОсновнойОбъект.ПолучитьСписокИсключений_Документы_Списки();
	
	менеджерМетаданного = Метаданные.Документы;
	Для Каждого МетаОбъект Из менеджерМетаданного Цикл
		
		Если ПравоДоступа("ИнтерактивноеДобавление", МетаОбъект) Тогда
			имяТеста = "ТестДолжен_ОткрытьФормуНовогоДокумента";
			ПрефиксПредставленияТеста = "Новые";
			СписокИсключений = СписокИсключений_Новые;
			ИменаОсновныхФорм = ИменаОсновныхФорм_Объекты_Сервер;
			ПроверяемоеПравоДоступа = "ИнтерактивноеДобавление";
			ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
		КонецЕсли;		
		
		имяТеста = "ТестДолжен_ОткрытьФормуСуществующегоЭлементаДокумента";
		ПрефиксПредставленияТеста = "Существующие";
		СписокИсключений = СписокИсключений_Существующие;
		ИменаОсновныхФорм = ИменаОсновныхФорм_Объекты_Сервер;
		
		ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);

		имяТеста = "ТестДолжен_ОткрытьФормуПоПолномуИмениФормы";
		ПрефиксПредставленияТеста = "Списки";
		СписокИсключений = СписокИсключений_Списки;
		ИменаОсновныхФорм = мИменаОсновныхФорм_Списки_Сервер;
		
		ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
	КонецЦикла;
КонецФункции

&НаСервере
Функция ДобавитьТестыДляОтчетовОбработокСервер(ОписанияТестов, ТолькоУправляемыеФормы)
	ОсновнойОбъект = Объект();
	
	ИменаОсновныхФорм = мИменаОсновныхФорм_Сервер();
	СписокИсключений_Отчеты = ОсновнойОбъект.ПолучитьСписокИсключений_Отчеты();
	СписокИсключений_Обработки = ОсновнойОбъект.ПолучитьСписокИсключений_Обработки();
	
	имяТеста = "ТестДолжен_ОткрытьФормуПоПолномуИмениФормы";
	ПрефиксПредставленияТеста = "";

	ДобавитьТестыПереданныхВидовФормДляКаждогоОбъектаМенеджераМетаданных(ОписанияТестов, ОсновнойОбъект, Метаданные.Обработки, ТолькоУправляемыеФормы, СписокИсключений_Обработки, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
	ДобавитьТестыПереданныхВидовФормДляКаждогоОбъектаМенеджераМетаданных(ОписанияТестов, ОсновнойОбъект, Метаданные.Отчеты, ТолькоУправляемыеФормы, СписокИсключений_Отчеты, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
КонецФункции

Процедура ДобавитьТестыПереданныхВидовФормДляКаждогоОбъектаМенеджераМетаданных(ОписанияТестов, ОсновнойОбъект, менеджерМетаданного, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста)
	Для Каждого МетаОбъект Из менеджерМетаданного Цикл
		Если ОсновнойОбъект.ЭтоУстаревшийМетаОбъектДляУдаления(МетаОбъект) Тогда
			Продолжить;
		КонецЕсли;
		Если Лев(МетаОбъект.Имя, СтрДлина("xddTestRunner")) = "xddTestRunner" Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста);
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьТестыПереданныхВидовФормПоОдномОбъектуМетаданных(ОписанияТестов, ОсновнойОбъект, МетаОбъект, 
		ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм, имяТеста, ПрефиксПредставленияТеста)
		
	Если ОсновнойОбъект.ЭтоУстаревшийМетаОбъектДляУдаления(МетаОбъект) Тогда
		Возврат;
	КонецЕсли;
		
	CписокИменМетаФорм = Новый СписокЗначений;
	ДобавитьИменаМетаФормДляОдногоОбъектаМетаданного(CписокИменМетаФорм, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, СписокИсключений, ИменаОсновныхФорм);
	ДобавитьТестПоПереданнымМетаФормамСсылочногоОбъектаСервер(ОписанияТестов, CписокИменМетаФорм, имяТеста, ПрефиксПредставленияТеста);
КонецПроцедуры

Процедура ДобавитьТестПоПереданнымМетаФормамСсылочногоОбъектаСервер(ОписанияТестов, CписокИменМетаФорм, имяТеста, ПрефиксПредставленияТеста)
	Для каждого Элемент Из CписокИменМетаФорм  Цикл
		МетаФорма_ПолноеИмя = Элемент.Значение;
		ПредставлениеТеста = МетаФорма_ПолноеИмя;
		Если НЕ ПустаяСтрока(ПрефиксПредставленияТеста) Тогда
			ПредставлениеТеста = ПрефиксПредставленияТеста + " : " + МетаФорма_ПолноеИмя;
		КонецЕсли;
		
		лПараметры = Новый Структура("ПредставлениеТеста,ИмяТеста,Транзакция,Параметр", ПредставлениеТеста, имяТеста, Истина, МетаФорма_ПолноеИмя);
		ОписанияТестов.Добавить(лПараметры);
	КонецЦикла;
КонецПроцедуры

Функция ИспользоватьОбычныеФормыВТолстомКлиентеВУправляемомРежимеСервер()
	Возврат Метаданные.ИспользоватьОбычныеФормыВУправляемомПриложении;
КонецФункции

&НаКлиенте
Процедура ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы) Экспорт
//Процедура ТестироватьФорму(ПолноеИмяФормы, ПараметрыФормы, Модально = Ложь) Экспорт
	Если Объект.ВыводитьСообщенияВЖурналРегистрации Тогда
		ВыполнитьЗаписьВЖурналРегистрации(ПолноеИмяФормы);
	КонецЕсли;
	
	КлючВременнойФормы = "908насмь9ыв3245";
	//Если Модально Тогда
	//	ТестируемаяФорма = ОткрытьФормуМодально(ПолноеИмяФормы, ПараметрыФормы);
	//Иначе
		//ошибка ="";
		//Попытка
		
		// К сожалению здесь исключения не ловятся https://github.com/xDrivenDevelopment/xUnitFor1C/issues/154
		ТестируемаяФорма = ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы,, КлючВременнойФормы);
		
		//Исключение
		//	ошибка = ОписаниеОшибки();
		//	Предупреждение(" поймали исключение 20" + ошибка);
		//КонецПопытки;
	//КонецЕсли;
	Если ТестируемаяФорма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//ТестируемаяФорма.Открыть(); // К сожалению здесь исключения не ловятся http://partners.v8.1c.ru/forum/thread.jsp?id=1080350#1080350
		Утверждения.Проверить(ТестируемаяФорма.Открыта(), "ТестируемаяФорма """+ПолноеИмяФормы+""" не открылась, а должна была открыться");
		
	Если ТипЗнч(ТестируемаяФорма) = Тип("УправляемаяФорма") Тогда
		ТестируемаяФорма.ОбновитьОтображениеДанных();
	Иначе
			//Если ЭтоОбычнаяФорма(ТестируемаяФорма) Тогда
		ТестируемаяФорма.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТестироватьФормуСсылочногоОбъекта(Мета_ПолноеИмя, СсылочныйОбъект)
	ПараметрыФормы = Новый Структура("Ключ", СсылочныйОбъект);
	ТестироватьФорму(Мета_ПолноеИмя, ПараметрыФормы);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗаписьВЖурналРегистрации(ПолноеИмяФормы)
	ЗаписьЖурналаРегистрации(Объект().Метаданные().Синоним, УровеньЖурналаРегистрации.Информация, , , "Операция: " + ПолноеИмяФормы);
КонецПроцедуры

&НаКлиенте
Процедура НачальнаяНастройка(КонтекстЯдра, Знач ПутьНастройки)

	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	
КонецПроцедуры

Процедура СоздатьИменаОсновныхФорм()
	ОсновнойОбъект = Объект();
	ОсновнойОбъект.СоздатьИменаОсновныхФорм();
	ОсновнойОбъект.ВидыМетаданных = ОсновнойОбъект.ВидыМетаданных();
	ОсновнойОбъект.ВидыПроверок = ОсновнойОбъект.ВидыПроверок();
	ЗначениеВРеквизитФормы(ОсновнойОбъект, "Объект");
КонецПроцедуры

&НаСервере
Функция ИменаОсновныхФорм_Объекты_Сервер()
	Возврат Объект().мИменаОсновныхФорм_Объекты;
КонецФункции

&НаСервере
Функция мИменаОсновныхФорм_Списки_Сервер()
	Возврат Объект().мИменаОсновныхФорм_Списки;
КонецФункции

&НаСервере
Функция мИменаОсновныхФорм_Сервер()
	Возврат Объект().мИменаОсновныхФорм;
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьИменаМетаФормДляОдногоОбъектаМетаданного(CписокИменМетаФорм, ОсновнойОбъект, МетаОбъект, ТолькоУправляемыеФормы, списокИсключений, ИменаОсновныхФорм)
	Если списокИсключений.НайтиПоЗначению(МетаОбъект.Имя) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ПравоДоступа("Просмотр", МетаОбъект) Тогда
		МетаФормы = ОсновнойОбъект.ПолучитьМетаФормыОбъектаДляПроверки(МетаОбъект, ИменаОсновныхФорм);

		Для каждого МетаФорма Из МетаФормы Цикл
			МетаФорма_ПолноеИмя = МетаФорма.ПолноеИмя();
			//Сообщить("МетаФорма_ПолноеИмя <"+МетаФорма_ПолноеИмя+"> ");
			
			Если ТолькоУправляемыеФормы Тогда
				//Сообщить("МетаФорма.ТипФормы <"+МетаФорма.ТипФормы+"> ");
				Если Не ЭтоУправляемаяФорма(МетаФорма) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
		
			CписокИменМетаФорм.Добавить(МетаФорма_ПолноеИмя);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоУправляемаяФорма(МетаФорма)
	Возврат МетаФорма <> Неопределено И МетаФорма.ТипФормы = Метаданные.СвойстваОбъектов.ТипФормы.Управляемая;
КонецФункции

Функция Объект()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

Функция ПолучитьВидМетаданного(Мета_ПолноеИмя)
	ИД = Лев(Мета_ПолноеИмя, Найти(Мета_ПолноеИмя, ".Форма.")-1);
	ИД = Сред(ИД, Найти(ИД, ".") + 1);
	Возврат ИД;
КонецФункции

&НаСервереБезКонтекста
Функция ИмяМетодаПропускаТестов()
	Возврат "ТестДолжен_ПропуститьТестФормы";		
КонецФункции

&НаКлиенте
Процедура ТестДолжен_ОткрытьФормуПоПолномуИмениФормы(ПолноеИмяФормы) Экспорт
	ТестироватьФорму(ПолноеИмяФормы, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ОткрытьФормуСуществующегоЭлементаСправочника(Мета_ПолноеИмя) Экспорт
	ТестДолжен_ОткрытьФормуСуществующегоЭлементаСправочникаСервер(Мета_ПолноеИмя);
	ТестироватьФормуСсылочногоОбъекта(Мета_ПолноеИмя, CоздаваемыйЭлемент);
КонецПроцедуры

&НаСервере
Процедура ТестДолжен_ОткрытьФормуСуществующегоЭлементаСправочникаСервер(Мета_ПолноеИмя)
	ИД = ПолучитьВидМетаданного(Мета_ПолноеИмя);

	ОсновнойОбъект = Объект();
	CоздаваемыйЭлемент = ОсновнойОбъект.СоздатьЭлементИВернутьСсылку(ИД, "существующий");
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ОткрытьФормуНовогоЭлементаСправочника(Мета_ПолноеИмя) Экспорт
	ТестироватьФормуСсылочногоОбъекта(Мета_ПолноеИмя, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ОткрытьФормуНовогоДокумента(Мета_ПолноеИмя) Экспорт
	ТестироватьФормуСсылочногоОбъекта(Мета_ПолноеИмя, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ОткрытьФормуСуществующегоЭлементаДокумента(Мета_ПолноеИмя) Экспорт
	Док = ТестДолжен_ОткрытьФормуСуществующегоЭлементаДокументаСервер(Мета_ПолноеИмя);
	Если Док <> Неопределено Тогда
		ТестироватьФормуСсылочногоОбъекта(Мета_ПолноеИмя, Док);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ТестДолжен_ОткрытьФормуСуществующегоЭлементаДокументаСервер(Мета_ПолноеИмя)
	ИД = ПолучитьВидМетаданного(Мета_ПолноеИмя);
	
	ОсновнойОбъект = Объект();
	Док = ОсновнойОбъект.ПолучитьСуществующийДокументОбъектИВернутьСсылку(ИД, НужноИсключениеЕслиНеНайденоДокументов, "ТестДолжен_ОткрытьФормуСуществующегоДокумента");
	Возврат Док;
КонецФункции

// проверка бага https://github.com/xDrivenDevelopment/xUnitFor1C/issues/154
&НаКлиенте
Процедура ТестДолжен_ПроверитьБагПлатформыПриОткрытииУправляемойФормыПриОткрытииКоторойЕстьИсключение() Экспорт
	Мета_ПолноеИмя = "Обработка.ТестОбработка_Форма_ИсключениеПриОткрытии.Форма.УправляемаяФорма";
	ошибка ="";
	Попытка
		ОткрытьФорму(Мета_ПолноеИмя);
	Исключение
		ошибка = ОписаниеОшибки();
		//Предупреждение("поймали исключение 20"+ ошибка);
	КонецПопытки;
	Утверждения.ПроверитьЗаполненность(ошибка, "Ошибка");
КонецПроцедуры

//} 
