# Uruchomienie
Należy uruchomić skrypt **kontoBankowe.sh**.

*Przy pierwszym uruchmieniu program wygeneruje testową bazę danych na podstawie skryptu fillDatabse.sh*

- Użytkownik  1:
    - login: **foo**
    - hasło: **1234**
- Użytkownik 2:
    - login: **bar**
    - hasło: **1234**

# Podstawowa struktura programu
- **Database** - przechowuje bazę danychh
- **Main** - logika apliikacji
    - **Auth** - autentykacja użytkownika
    - **Database** - komunikacja z bazą danych
    - **Home** - rdzeń aplikacji oparty o *ViewController*
        - Component 1
        - Component 2
        - Component ...
        - view.sh *# powinienem stworzyć folder Views z plikiem index.sh*
        - controller.sh *# powinienem stworzyć folder Controllers z plikiem index.sh*
    - **Utils** - globalne funkcje
    - **globals.sh** - globalne zmienne
- **fillDatabse.sh** - wypełnia bazę danych do potrzeb developerskich
- **kontoBankowe.sh** - uruchamia aplikację
- **test.sh** - uruchamia testy