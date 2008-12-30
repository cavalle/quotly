Feature: q.uot.es main page
  In order get interested on q.uot.es
  As an eventual visitor
  I want to see the best q.uot.es has to offer
  
  Scenario: See latest quotes
  
    Given the following quotes has been created:
    | text                            | author              |
    | In the end, everything is a gag | Charlie Chaplin     |
    | A joke is a very serious thing  | Winston Churchill   |
    | Brevity is the soul of wit      | William Shakespeare |
    
    When I visit the home page of q.uot.es
    
    Then I should see the following quotes:
    | text                            | author              |
    | In the end, everything is a gag | Charlie Chaplin     |
    | A joke is a very serious thing  | Winston Churchill   |
    | Brevity is the soul of wit      | William Shakespeare |
    