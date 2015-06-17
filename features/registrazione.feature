# language: it
Funzionalità: registrazione utente
  Come utente anonimo volgio registrami sulla piattaforma 
  per poter accedere ai servizi che offre

Contesto:
  Dato che esistono gli utenti: 
    | username | password | email                  |status|
    | test     | letmein   | test@knplabs.com      |active|
    | inactive | letmein   | inactive@symfony.com  |inactive|
    | disable  | letmein   | disavle@symfony.com   |disable|
   

  Scenario: Registration ok
    Quando faccio POST su "/v1/registrazione" con body "url-encoded"
    """
    user=newuser&password=prova1234&nome=pippo&cognome=pluto
    """
    
    Allora lo status code è “200”
    E il body è JSON
    E la risposta contiene JSONPath $.username
    E la risposta contiene JSONPath $.userid
    E la risposta contiene JSONPath $.fullname


  Schema dello Scenario: Utente  
    Quando faccio POST su “/v1/login” con body “url-encoded”
    """
    <qstring_credenziali>
    """
    Allora lo status code è “400”
    E la risposta contiene JSONPath $.error
      Esempi:
      | qstring_credenziali |
      | user=test&pass=sbagliata |
      | user=sbagliata&pass=sbagliata |
      | user=&pass=|
      | user=test&pass=|
      | user=&pass=letmein|
    


  #alternativa con header esplicto nella request 
  Scenario: Login successful (http style)
    Dato che ho un requestbody 
    """
    user=test&password=letmein
    """
    E ho un header "Content-Type" "application/x-www-form-urlencoded"
    #nel post ci saranno gli header definiti sopra

    Quando faccio  POST su “/v1/login”
    Allora lo status code è "200"
    E esiste un header "Content-Type" "application/json"
    E la risposta contiene JSONPath $.username
    E la risposta contiene JSONPath $.userid
    E la risposta contiene JSONPath $.fullname

    
