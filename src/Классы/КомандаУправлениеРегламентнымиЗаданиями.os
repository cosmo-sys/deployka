
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Перем мНастройки;
Перем Лог;

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Управление регламентынми заданиями информационной базы");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Действие", "on|off");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-ras", "Сетевой адрес RAS, по умолчанию localhost:1545");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-rac", "Команда запуска RAC, по умолчанию находим в каталоге установки 1с");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-db", "Имя информационной базы");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-db-user",
		"Пользователь информационной базы");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-db-pwd",
		"Пароль пользователя информационной базы");
		
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-cluster-admin",
		"Администратор кластера");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-cluster-pwd",
		"Пароль администратора кластера");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
		"-v8version",
		"Маска версии платформы 1С");
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры

Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт

	ПрочитатьПараметры(ПараметрыКоманды);
	
	Если Не ПараметрыВведеныКорректно() Тогда
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;

	СерверАдминистрирования = Новый СерверАдминистрирования;

	СерверАдминистрирования.Инициализация(мНастройки.АдресСервераАдминистрирования,
	                                      мНастройки.ПутьКлиентаАдминистрирования,
	                                      мНастройки.ИмяБазыДанных,
	                                      мНастройки.АдминистраторИБ,
	                                      мНастройки.ПарольАдминистратораИБ,
	                                      мНастройки.АдминистраторКластера,
	                                      мНастройки.ПарольАдминистратораКластера,
	                                      мНастройки.ИспользуемаяВерсияПлатформы);

	Если мНастройки.Действие = "off" Тогда
		СерверАдминистрирования.УстановитьСтатусБлокировкиРегламентныхЗаданий(Истина);
	ИначеЕсли мНастройки.Действие = "on" Тогда
		СерверАдминистрирования.УстановитьСтатусБлокировкиРегламентныхЗаданий(Ложь);
	Иначе
		Лог.Ошибка("Неизвестное действие: " + мНастройки.Действие);
		Возврат МенеджерКомандПриложения.РезультатыКоманд().НеверныеПараметры;
	КонецЕсли;

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
	
КонецФункции

Процедура ПрочитатьПараметры(Знач ПараметрыКоманды)
	мНастройки = Новый Структура;
	
	Для Каждого КЗ Из ПараметрыКоманды Цикл
		Лог.Отладка(КЗ.Ключ + " = " + КЗ.Значение);
	КонецЦикла;
	
	мНастройки.Вставить("АдресСервераАдминистрирования", ПараметрыКоманды["-ras"]);
	мНастройки.Вставить("ПутьКлиентаАдминистрирования", ПараметрыКоманды["-rac"]);
	мНастройки.Вставить("ИмяБазыДанных", ПараметрыКоманды["-db"]);
	мНастройки.Вставить("АдминистраторИБ", ПараметрыКоманды["-db-user"]);
	мНастройки.Вставить("ПарольАдминистратораИБ", ПараметрыКоманды["-db-pwd"]);
	мНастройки.Вставить("АдминистраторКластера", ПараметрыКоманды["-cluster-admin"]);
	мНастройки.Вставить("ПарольАдминистратораКластера", ПараметрыКоманды["-cluster-pwd"]);
	мНастройки.Вставить("ИспользуемаяВерсияПлатформы", ПараметрыКоманды["-v8version"]);
		
	мНастройки.Вставить("Действие", ПараметрыКоманды["Действие"]);
	
КонецПроцедуры

Функция ПараметрыВведеныКорректно()
	
	Успех = Истина;
	
	Если Не ЗначениеЗаполнено(мНастройки.ИмяБазыДанных) Тогда
		Лог.Ошибка("Не указано имя базы данных");
		Успех = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мНастройки.Действие) Тогда
		Лог.Ошибка("Не указано действие on|off");
		Успех = Ложь;
	КонецЕсли;
	
	Возврат Успех;
	
КонецФункции

Лог = Логирование.ПолучитьЛог("vanessa.app.deployka");
