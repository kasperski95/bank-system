# Uruchomienie
Należy uruchomić skrypt **kontoBankowe.sh**.
Aby zakończyć działanie skryptu należy wcisnąć **CTRL+C**.

*Przy pierwszym uruchmieniu program wygeneruje developerską bazę danych na podstawie skryptu fillDatabse.sh*

- Użytkownik 0:
    - login: **bank**
    - hasło: **1234**
- Użytkownik 1:
    - login: **foo**
    - hasło: **1234**
- Użytkownik 2:
    - login: **bar**
    - hasło: **1234**

# Podstawowa struktura programu
- **Database** - przechowuje bazę danych
- **Main** - logika apliikacji
    - **Auth** - autentykacja użytkownika
    - **Database** - komunikacja z bazą danych
    - **Home** - główny komponent aplikacji
        - Component 1
        - Component 2
        - Component ...
        - view.sh
        - controller.sh
    - **Utils** - globalne funkcje
    - **globals.sh** - globalne zmienne
- **fillDatabse.sh** - wypełnia bazę danych do potrzeb developerskich
- **kontoBankowe.sh** - uruchamia aplikację
- **test.sh** - uruchamia testy

# Nazewnictwo
- __ - funkcje prywatna
- db_ - przedrostek (w tym przypadku dla funkcji komunikujących się z bazą danych) w celu ułatwienia zrozumienia kodu w programowaniu proceduralnym
- GLOBAL - zmienne napisane wielkimi literami są globalne (zasada ta nie tyczy się zmiennych: *^.*_dir$* bo nie chce mi się tego zmieniać - powinny się nazywać __PRZEDROSTEK_DIR)

# Hindsight
- Zamiast tworzyć pliki view.sh i controller.sh, utworzyłbym foldery Views i Controllers z plikami index.sh.
- View powinnien być zależny od Controllera.