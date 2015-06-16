# language: it
Funzionalità: login
  Come utente della piattaforma
  Voglio autenticarmi
  Così che io possa salvare i documenti, essere riconoscibile...

  Contesto:
   Dato che esiste l’utente “test” con password “letmein”
   

#   Scenario: Login successful
#     Quando faccio POST su “/v1/login” con body “url-encoded”
#     """
#     user=test&password=letmein
#     """
#     
#     Allora lo status code è “200”
#     E il body è JSON
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
    E la risposta contiene JSONPath "$.error"
      Esempi:
      | qstring_credenziali |
      | user=test&password=sbagliata |
      | user=sbagliata&password=sbagliata |
      | user=&password=|
      | user=test&password=|
      | user=&password=letmein|
    


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

    
