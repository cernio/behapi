# language: it
Funzionalità: login
  Come utente della piattaforma
  Voglio autenticarmi
  Così che io possa salvare i documenti, essere riconoscibile...


Contesto:
  Dato che esistono gli utenti: 
    | username | password | email                  |status|
    | test     | letmein   | test@knplabs.com   |active|
    | inactive | letmein   | inactive@symfony.com  |inactive|
    | disable  | letmein   | disavle@symfony.com   |disable|




  Scenario: Login successful
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    user=test&password=letmein
    """    
   Allora lo status code è "200"
    
    E la risposta contiene JSONPath "$.username"
#     E la risposta contiene JSONPath $.username
#     E la risposta contiene JSONPath $.userid
#     E la risposta contiene JSONPath $.fullname

  # Schema dello scenario: o Scenario outline: si usa quando lo scenario prende degli esempi per l'esecuzione
  Schema dello scenario: Login incorrect 
    Quando faccio POST su "/v1/login" con body "url-encoded"
    """
    <qstring_credenziali>
    """
    Allora lo status code è "400"
    E il body è JSON
    E la risposta contiene JSONPath "$.error"
      Esempi:
      | qstring_credenziali |
      | user=test&pass=sbagliata |
      | user=sbagliata&pass=sbagliata |
      | user=&pass=|
      | user=test&pass=|
      | user=&pass=letmein|
    
  # Schema dello scenario: o Scenario outline: si usa quando lo scenario prende degli esempi per l'esecuzione
#   Schema dello scenario: User not active
#     Quando faccio POST su "/v1/login" con body "url-encoded"
#     """
#     <qstring_credenziali>
#     """
#     Allora lo status code è "403"
#     E il body è JSON
#     E la risposta contiene JSONPath "$.error"
#       Esempi:
#       | qstring_credenziali |
#       | user=inactive&pass=letmin |
#       | user=disable&pass=letmin |
    


#   #alternativa con header esplicto nella request 
#   Scenario: Login successful (http style)
#     Dato che ho un request body 
#     """
#     user=test&password=letmein
#     """
#     E ho un header "Content-Type" "application/x-www-form-urlencoded"
#     
#     
#     Quando faccio POST su "/v1/login"
#     #nel post ci saranno gli header definiti sopra
# 
#     Allora lo status code è "200"
#     E esiste un header "Content-Type" "application/json"
#     E la risposta contiene JSONPath "$.username"
#     E la risposta contiene JSONPath "$.userid"
#     E la risposta contiene JSONPath "$.fullname"

    
