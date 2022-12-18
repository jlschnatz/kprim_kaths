if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}
pacman::p_load(shiny, tidyverse, data.table, DT)

#   Example from Yihui Shiny Apps -------------------------------------------
#   see: https://yihui.shinyapps.io/DT-radio/

shinyApp(
  ui = fluidPage(
    title = "Radio buttons in a table",
    DT::dataTableOutput("foo"),
    verbatimTextOutput("sel")
  ),
  server = function(input, output, session) {
    m <- matrix(
      as.character(1:5),
      nrow = 12, ncol = 5, byrow = TRUE,
      dimnames = list(month.abb, LETTERS[1:5])
    )
    for (i in seq_len(nrow(m))) {
      m[i, ] <- sprintf(
        '<input type="radio" name="%s" value="%s"/>',
        month.abb[i], m[i, ]
      )
    }
    m
    output$foo <- DT::renderDataTable(
      m,
      escape = FALSE, selection = "none", server = FALSE,
      options = list(dom = "t", paging = FALSE, ordering = FALSE),
      callback = JS("table.rows().every(function(i, tab, row) {
          var $this = $(this.node());
          $this.attr('id', this.data()[0]);
          $this.addClass('shiny-input-radiogroup');
        });
        Shiny.unbindAll(table.table().node());
        Shiny.bindAll(table.table().node());")
    )
    output$sel <- renderPrint({
      str(sapply(month.abb, function(i) input[[i]]))
    })
  }
)

# Implement own example ----

test_data <- tibble(
  Item = c(
    "Geringes Schlafbedürfnis", "Interessensverlust oder Freudlosigkeit",
    "Agitation oder Verlangsamung", "Konzetrationsschwäche oder Inhibition"
  ),
  Richtig = rep(1, 4),
  Falsch = rep(2, 4)
) %>%
  mutate(across(
    .cols = Richtig:Falsch,
   .fns = ~ sprintf('<input type="radio" name="%s" value="%s"/>', Item, .x)
  ))

title <- paste0(
  "Welcher der folgenden Symptome stehen / stehen nicht im Zusammenhang ",
  "mit einer einzigen Episode einer schweren depressiven Störung nach ICD-10"
)

datatable(test_data, escape = FALSE, options = list(dom = "t", 
                                                    paging = FALSE, 
                                                    ordering = FALSE,
                                                    fullwidth = FALSE))

ui <- fluidPage(
  title = titlePanel("Shiny Test: Kprim"),
  h4(title),
  DT::dataTableOutput("table")
  )

server <- function(input, output, session) {
  output$table <- DT::renderDataTable(
    expr = test_data,
    escape = FALSE,
    selection = "none",
    server = FALSE,
    options = list(dom = "t", paging = FALSE, ordering = FALSE)
  )
}

shinyApp(ui, server)


