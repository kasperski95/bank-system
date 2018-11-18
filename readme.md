# Uruchomienie
Należy uruchomić skrypt **kontoBankowe.sh**.
Aby zakończyć działanie skryptu należy wcisnąć **CTRL+C**.

*Przy pierwszym uruchmieniu skrypt wygeneruje developerską bazę danych na podstawie skryptu createDatabase.sh*

- Użytkownik 0:
    - login: **bank**
    - hasło: **1234**
- Użytkownik 1:
    - login: **zus**
    - hasło: **1234**
- Użytkownik 2:
    - login: **foo**
    - hasło: **1234**
- Użytkownik 3:
    - login: **bar**
    - hasło: **1234**

# Podstawowa struktura programu
- **Database** - baza danych wygenerowana przez createDatabase.sh
- **Main** - logika apliikacji
    - **Auth** - autentykacja użytkownika
    - **Database** - komunikacja z bazą danych
    - **Home** - główny komponent aplikacji
        - Component 1
        - Component 2
        - Component ...
        - view.sh
        - controller.sh
    - **Utils** - uniwersalne funkcje
    - **globals.sh** - zmienne globalne
- **createDatabase.sh** - tworzy bazę danych i wypełnia ją dla potrzeb developerskich
- **kontoBankowe.sh** - uruchamia aplikację
- **test.sh** - uruchamia testy (nieliczne, ze względu na oszczędność czasu i braku planu utrzymywania aplikacji)

# Nazewnictwo
- __ - funkcje prywatna
- db_ - przedrostek (w tym przypadku dla funkcji komunikujących się z bazą danych) w celu ułatwienia zrozumienia kodu w programowaniu proceduralnym
- GLOBAL - zmienne napisane wielkimi literami są globalne (zasada ta nie tyczy się zmiennych: *^.*_dir$* bo nie chce mi się tego zmieniać - powinny się nazywać __PRZEDROSTEK_DIR)

# Hindsights
- Zamiast tworzyć pliki view.sh i controller.sh, utworzyłbym foldery Views i Controllers z plikami index.sh.
- View powinnien być zależny od Controllera.
- Do komunikacji z bazą danych lepiej było na samym początku zaimplementować coś w rodzaju ORM.
- Przy braku Intellisense, lepiej ograniczyć się z ilością funkcji.
- Refaktoryzuj przy 3-cim powtórzeniu schematu / kodu.