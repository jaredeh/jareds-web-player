Feature:  Heat coloring
  In order to track what each served up host is doing
  I want to have blue be cold, yellow hot, and red half way

  Scenario: cold
    Given a heat value the function should return a rgb array:
      | heat | r   | g   | b   |
      | 0    | 0   | 0   | 255 |
      | 100  | 255 | 255 | 0   |
      | 50   | 255 | 0   | 0   |
      | 25   | 127 | 0   | 127 |
      | 75   | 255 | 127 | 0   |
