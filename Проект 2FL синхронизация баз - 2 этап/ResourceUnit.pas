﻿{unit ResourceUnit
Версия: 1.0 от 17.10
Разработчик: Соколовский Николай
Sokolovskynik@gmail.com


Юнит хранит строковые ресурсы для отображения сообщений на русском, английском, немецком языках}

unit ResourceUnit;

interface

resourcestring
 //блок русских текстов
 sresFileRU = 'Файл';
 sresSettingRU = 'Настройка';
 sresHelpRU = 'Помощь';
 sresNothingRU = 'Ни одной';
 sresAllRU = 'Все';
 sresSynchronizationRU = 'Синхронизировать';
 sresConProtocolRU = 'Протокол подключения';
 sresSynchProtocolRU = 'Протокол сихронизации';
 sresSaveLogRU = 'Сохранить лог';
 sresExitRU = 'Выход';
 sresPassRU = 'Пароль';
 sresLangRU = 'Язык';
 sresRusRU = 'Русский';
 sresEngRU = 'Английский';
 sresDeuRU = 'Немецкий';
 sresRefRU = 'Справка';
 sresAboutProgRU = 'О программе';
 sresSolConflictRU = 'Разрешение коллизии';
 sresConflictRU = 'Обнаружена коллизия. Пожалуйста, укажите направление копирования';
 sresCopyAllRU = 'Копировать все';
 sresOkRU = 'Ок';
 sresSkipRU = 'Пропустить';
 sresSkipAllRU = 'Пропустить все';
 sresUserNameRU = 'Имя пользователя';
 sresOldPassRU = 'Старый пароль';
 sresNewPassRU = 'Новый пароль';
 sresRepNewPassRU = 'Повторите новый пароль';
 sresAcceptRU = 'Применить';
 sresCancelRU = 'Отмена';
 sresChangePassRU = 'Смена пароля';
 sresSynchDBRU = 'Синхронизация баз данных';
 sresStartSynchRU = 'Старт синхронизации';
 sresDChangeUSBRU = 'Не выбран сменный носитель. Пожалуйста выберите сменный диск с базой данных';
 sresSettingAbsentRU = 'Файл настроек не найден. Синхронизация не возможна.';
 sresNoArgLlocalSQLiteRU = 'Параметр размещения БД SQLite не найден. Укажите путь вручную.';
 sresNoPathSQLiteRU = 'Путь к БД SQLite не указан. Работа будет завершена.';
 sresNoArgLocalFireBirdRU = 'Параметр размещения БД FireBird не найден. Укажите путь вручную.';
 sresNoPathFireBirdRU = 'Путь к БД FireBird не указан. Работа будет завершена.';
 sresSettingSuuccessRU = 'Чтение настроек - успешно';
 sresErrorRU = 'Ошибка';
 sresErrorConSQLiteRU = 'Ошибка подключения к базе SQLite:';
 sresConnectSQLiteRU = 'Подключение к базе SQLite:';
 sresSuccessRU = '- успешно';
 sresErrorConFireBirdRU = 'Ошибка подключения к базе FireBird:';
 sresConnectFireBirdRU = 'Подключение к базе FireBird:';
 sresTakingListFieldRU = 'Получение списка полей - успешно';
 sresBeginSynchRU = 'Начало синхронизации';
 sresFinishSynchRU = 'Cинхронизация завершена';
 sresTableRU = 'Таблица';
 sresRecordCountRU = 'Кол-во записей';
 sresNoEqualPassRU = 'Введенные пароли не совпадают';
 sresNoSuchPassUserRU = 'Не найдено поле пароля пользователя. Изменение не возможно.';
 sresNoSuchUserNameRU = 'Не найдено поле имени пользователя. Изменение не возможно.';
 sresNoSuchTabPassRU = 'Не найдено имя таблицы паролей. Изменение не возможно.';
 sresProgressRU = 'Прогресс';

 //блок английских текстов
 sresFileENG = 'File';
 sresSettingENG = 'Setting';
 sresHelpENG = 'Help';
 sresNothingENG = 'None';
 sresAllENG = 'All';
 sresSynchronizationENG = 'Synchronize';
 sresConProtocolENG = 'Connection log';
 sresSynchProtocolENG = 'Synchronization log';
 sresSaveLogENG = 'Save log';
 sresExitENG = 'Exit';
 sresPassENG = 'Password';
 sresLangENG = 'Language';
 sresRusENG = 'Russian';
 sresEngENG = 'English';
 sresDeENG = 'German';
 sresRefENG = 'Help';
 sresAboutProgENG = 'About';
 sresSolConflictENG = 'Soluting conflict';
 sresConflictENG = 'Conflict detected. Please, choose copying direction';
 sresCopyAllENG = 'Copy all';
 sresOkENG = 'Ok';
 sresSkipENG = 'Skip';
 sresSkipAllENG = 'Skip all';
 sresUserNameENG = 'User name';
 sresOldPassENG = 'Old password';
 sresNewPassENG = 'New password';
 sresRepNewPassENG = 'Repeat new password';
 sresAcceptENG = 'Apply';
 sresCancelENG = 'Cancel';
 sresChangePassENG = 'Change password';
 sresSynchDBENG = 'Synchronizing DB';
 sresStartSynchENG = 'Start synchronization';
 sresDChangeUSBENG = 'Removable disk wasn’t chosen. Please, choose the disk with DB';
 sresSettingAbsentENG = 'Settings file is not found. Synchronization is impossible. ';
 sresNoArgLlocalSQLiteENG = 'SQLite-DB path setting is not found. Please, specify the path.';
 sresNoPathSQLiteENG = 'The path to SQLite-DB is not specified. Application will terminate.';
 sresNoArgLocalFireBirdENG = 'FireBird-DB path setting is not found. Please, specify the path.';
 sresNoPathFireBirdENG = 'The path to FireBird -DB is not specified. Application will terminate.';
 sresSettingSuuccessENG = 'Read setting – success.';
 sresErrorENG = 'Error';
 sresErrorConSQLiteENG = 'SQLite-DB Connection Error:';
 sresConnectSQLiteENG = 'Connecting to SQLite:';
 sresSuccesseENG = '-success';
 sresErrorConFireBirdENG = 'FireBird-DB Connection Error:';
 sresConnectFireBirdENG = 'Connecting to FireBird:';
 sresTakingListFieldENG = 'Reading fields list - success';
 sresBeginSynchENG = 'Synchronization begins';
 sresFinishSynchENG = 'Synchronization finished';
 sresTableENG = 'Table';
 sresRecordCountENG = 'Record Count';
 sresNoEqualPassENG = 'The passwords are not equal';
 sresNoSuchPassUserENG = 'Password field not found. Changing impossible.';
 sresNoSuchUserNameENG = 'Username field not found. Changing impossible.';
 sresNoSuchTabPassENG = 'Passwords table name not found. Changing impossible.';
 sresProgressENG = 'Progress';

 //Немецкие тексты
 sresFileDE = 'Datei';
 sresSettingDE = 'Einstellungen';
 sresHelpDE = 'Hilfe';
 sresNothingDE = 'Keine';
 sresAllDE = 'Alle';
 sresSynchronizationDE = 'Synchronisieren';
 sresConProtocolDE = 'Verbindungsprotokoll';
 sresSynchProtocolDE = 'Synchronisationsprotokoll';
 sresSaveLogDE = 'Protokoll speichern';
 sresExitDE = 'Beenden';
 sresPassDE = 'Passwort';
 sresLangDE = 'Sprache';
 sresRusDE = 'Russisch';
 sresEngDE = 'Englisch';
 sresDeDE = 'Deutsch';
 sresRefDE = 'Hilfe';
 sresAboutProgDE = 'Über';
 sresSolConflictDE = 'Kollisionslösung';
 sresConflictDE = 'Kollisionerkannt. Bitte zeigen Sie eine Richtung fürs Ersetzen.';
 sresCopyAllDE = 'Alles ersetzen';
 sresOkDE = 'Ok';
 sresSkipDE = 'Überspringen';
 sresSkipAllDE = 'Alles überspringen';
 sresUserNameDE = 'Benutzername';
 sresOldPassDE = 'Altes Kennwort';
 sresNewPassDE = 'Neues Kennwort';
 sresRepNewPassDE = 'Neues Kennwort bestätigen';
 sresAcceptDE = 'Anwenden';
 sresCancelDE = 'Abbrechen';
 sresChangePassDE = 'Kennwort ändern';
 sresSynchDBDE = 'Datenbank Synchronisation';
 sresStartSynchDE = 'Synchronisation starten';
 sresDChangeUSBDE = 'Wechselmedien ist nicht ausgewählt. Bitte wählen Sie das Medien mit der Datenbank';
 sresSettingAbsentDE = 'Konfigurationsdatei ist nicht gefunden. Synchronisation ist nicht möglich.';
 sresNoArgLlocalSQLiteDE = 'SQLite-DB Pfadkofiguration ist nicht gefunden. Bitte geben Sie den Pfad direkt ein.';
 sresNoPathSQLiteDE = 'Der Pfad zur SQLite-Datenbank ist nicht angegeben. Anwendung wird beendet.';
 sresNoArgLocalFireBirdDE = 'FireBird-DB Pfadkofiguration ist nicht gefunden. Bitte geben Sie den Pfad direkt ein.';
 sresNoPathFireBirdDE = 'Der Pfad zur FireBird-Datenbank ist nicht angegeben. Anwendung wird beendet.';
 sresSettingSuuccessDE = 'Einstellungen gelesen – erfolgreich.';
 sresErrorDE = 'Fehler';
 sresErrorConSQLiteDE = 'SQLite-DB Verbindungsfehler';
 sresConnectSQLiteDE = 'Verbundung zur SQLite-DB:';
 sresSuccesseDE = '- erfolgreich';
 sresErrorConFireBirdDE = 'FireBird-DB Verbindungsfehler';
 sresConnectFireBirdDE = 'Verbundung zur FireBird-DB:';
 sresTakingListFieldDE = 'Liste der Felder bekommen – erfolgreich';
 sresBeginSynchDE = 'Synchronisationsbeginn';
 sresFinishSynchDE = 'Synchronisationsende';
 sresTableDE = 'Tabelle';
 sresRecordCountDE = 'Anzahl der Einträge';
 sresNoEqualPassDE = 'Die Passwörter sind nicht gleich';
 sresNoSuchPassUserDE = 'Passwortfeld nicht gefunden. Änderung ist nicht möglich.';
 sresNoSuchUserNameDE = 'Benutzernamefeld nicht gefunden. Änderung ist nicht möglich.';
 sresNoSuchTabPassDE = 'Name der Passworttabelle nicht gefunden. Änderung ist nicht möglich.';
 sresProgressDE = 'Progress';


implementation

end.
