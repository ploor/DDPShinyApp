library(shiny)

# Define UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Correlated Data Generator"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      actionButton("goButton","Generate Data"),
      downloadButton('downloadData', 'Download Data'),
      numericInput("numObs", label = "Number of observations:", value = 1000),
      numericInput("numObsToPlot", label = "Number of observations to plot:", value = 100),
      numericInput("seed", label = "Seed for random number generator:", value = 1234),
      textInput("var1Name", label = "Name of variable 1", value = "var1.name"),
      textInput("var2Name", label = "Name of variable 2", value = "var2.name"),
      textInput("var3Name", label = "Name of variable 3", value = "var3.name"),
      numericInput("corr12", label = "Correlation(var1,var2)", value = 0, min = -1, max = 1,
                   step = 0.00000001),
      numericInput("corr13", label = "Correlation(var1,var3)", value = 0, min = -1, max = 1,
                   step = 0.00000001),
      numericInput("corr23", label = "Correlation(var2,var3)", value = 0, min = -1, max = 1,
                   step = 0.00000001)
    ),
    
    # Show a plot and a helper for setting the correlations
    mainPanel(
      p("Click ", strong("Generate Data"), " to ", em("create"), " and ", em("plot"), " simulated data according to the parameters specified.  The correlation structure is specified using the last 3 widgets on the left.  The ", strong("Correlation Helper"), " at the bottom of the page can be used to assist with the selection of possible combinations of variable correlations."),
      plotOutput("distPlot"),
      h4("Correlation helper"),
      p("The correlation matrix needs to be positive definite.  Given 2 of the correlations, the third correlation needs to be in the following ranges:"),
      textOutput("text1"),
      textOutput("text2"),
      textOutput("text3")
    )
  )
))