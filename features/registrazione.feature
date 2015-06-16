# language: it
Funzionalità: registrazione utente
  Come utente della piattaforma
  Voglio autenticarmi
  Così che io possa salvare i documenti, essere riconoscibile...

  Contesto:
   Dato che esiste l’utente “test” con password “letmein”
   

  Scenario: Login successful
    Quando faccio POST su “/v1/login” con body “url-encoded”
    """
    user=test&password=letmein
    """
    
    Allora lo status code è “200”
    E il body è JSON
    E la risposta contiene JSONPath $.username
    E la risposta contiene JSONPath $.userid
    E la risposta contiene JSONPath $.fullname


  Schema dello Scenario: Login incorrect 
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

    
