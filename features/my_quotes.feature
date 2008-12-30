Feature: My q.uot.es
  In order to be passionate about q.uot.es
  As a q.uot.es user
  I want to have access to the quotes i like the most
  
  Scenario: User goes to his/her page and sees the quotes he/she has created
    
    Given I'm logged in as Paloma
    And I've created the following quotes:
    | text                                                                     | author           | source              |
    | Todas las conquistas sublimes son, más o menos, premios al atrevimiento. | Victor Hugo      | Los miserables      |
    | […] su sonrisa no disipó el dolor, pero lo hizo más transitable. […]     | Almudena Grandes | Castillos de cartón |
    And Luismi has created the following quotes:
    | text                                                        | author    | source       |
    | Testing is not the point. The point is about responsibility | Kent Beck | RailsConf'08 |
    
    When I go to /
    
    Then I should see the quote "Todas las conquistas sublimes son, más o menos, premios al atrevimiento." by Victor Hugo (Los miserables)
    And I should see the quote "[…] su sonrisa no disipó el dolor, pero lo hizo más transitable. […]" by Almudena Grandes (Castillos de cartón)
    And I should not see the quote "Testing is not the point. The point is about responsibility" by Kent Beck (RailsConf'08)
        
  Scenario: User goes to his/her page and sees his/her favorites quotes
  
  Scenario: User goes to his/her page and sees the quotes created by the people he/she follow
  
    Given I'm Paloma, a q.uot.es registered user
    And Nuria has created the following quotes:
    | text                                                                | author    |
    | Education is not the filling of a bucket but the lighting of a fire | W.B Yeats |
    And I'm following Nuria in q.uot.es
    
    When I log in
    
    Then I should see the quote "Education is not the filling of a bucket but the lighting of a fire" by W.B Yeats
  