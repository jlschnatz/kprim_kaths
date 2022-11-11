library(mirtCAT)

# Erst Itemstämme
questions <- c("Building CATs with mirtCAT is difficult.",
               "Building tests with mirtCAT requires a lot of coding.",
               "Das hier ist das custom-Item")
# Antwortoptionen
options <- matrix(c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"),
                  nrow = 3, ncol = 5, byrow = TRUE)
# korrekte Antwort pro item -> ergibt bei Likert-items natürlich nicht so viel Sinn ;)
answer <- matrix(c("Disagree", "Agree", "Strongly Agree"),
                 nrow = 3, ncol = 1, byrow = TRUE)

# alles zusammenbauen in einen data-frame unter Angabe des Itemstypus
df <- data.frame(Question = questions, Option = options, Answer = answer, 
                 Type = c("radio", "radio", "custom.item")) ####hier wird der Itemtypus spezifiziert. Für eigene Itemtypen muss ein name überlegt werden. Dieser ist in diesem Fall "custom.item"


custom.item <- function(inputId, df_row){ 
  #für eigene Itemtypen muss eine funktion geschrieben werden, die die inputID des Items, 
  # sowie die Reihe im Item-df als input nimmt.
  list( 
    #in dieser funktion kann man nun verschiedene shiny-objekte in eine Liste zusammenpacken. 
    h3(df_row$Question), 
    #in diesem Fall ist es einfach der Stimulus als größere Schrift (h3 in der HTML-Welt)
    #sowie ein Radio-Button-Input element, dass nur die ersten zwei Antwortoptionen aus dem 
    # df nimmt-->hier müsste also irgendwo der Code-input hin
    radioButtons(
      inputId = inputId, 
      label='', 
      selected = '',
      choices = with(df_row, c(Option.1, Option.2))
      )
  )
}


results <- mirtCAT(
  #mirtCAT-funktion die local einen Test startet mit den Items oben. das dritte item ist das custom-item
  df=df, 
  #neben dem df muss nun für jeden custom-type auch die entsprechende Funktion an mirtCAT übergeben werden
  customTypes = list(custom.item = custom.item)
  ) 
print(results)
summary(results)
