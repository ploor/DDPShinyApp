library(shiny)

# Define server logic
shinyServer(function(input, output) {
  
  # Define data frame so it is available for downloading
  raw <- data.frame(Date=as.Date(character()),
                   File=character(), 
                   User=character(), 
                   stringsAsFactors=FALSE) 
  
  # Render a plot when the go button is clicked
  output$distPlot <- renderPlot({
    input$goButton
    isolate({R <- matrix(cbind(1,input$corr12,input$corr13,  input$corr12,1,input$corr23,  input$corr13,input$corr23,1),nrow=3);
             U <- t(chol(R));
             nvars <- dim(U)[1];
             numobs <- input$numObs;
             set.seed(input$seed);
             random.normal <- matrix(rnorm(nvars*numobs,0,1), nrow=nvars, ncol=numobs);
             X <- U %*% random.normal;
             newX <- t(X);
             raw <<- as.data.frame(newX);
             names(raw) <<- c(input$var1Name,input$var2Name,input$var3Name);
             plot(head(raw, min(input$numObs,input$numObsToPlot)));})
  })
  
  
  # Reactive output to determine permissible ranges of correlations  
  output$text1 <- renderText({ 
    paste(input$corr23*input$corr13-sqrt((1-input$corr23^2)*(1-input$corr13^2)), " < Correlation(var1,var2) < ", input$corr23*input$corr13+sqrt((1-input$corr23^2)*((1-input$corr13)^2)))
  })
  output$text2 <- renderText({ 
    paste(input$corr12*input$corr23-sqrt((1-input$corr12^2)*(1-input$corr23^2)), " < Correlation(var1,var3) < ", input$corr12*input$corr23+sqrt((1-input$corr12^2)*(1-input$corr23^2)))
  })
  output$text3 <- renderText({ 
    paste(input$corr12*input$corr13-sqrt((1-input$corr12^2)*(1-input$corr13^2)), " < Correlation(var2,var3) < ", input$corr12*input$corr13+sqrt((1-input$corr12^2)*(1-input$corr13^2)))
  })
  
  # data downloader
  output$downloadData <- downloadHandler(
    filename = "data.csv",
    content = function(file) {
      write.csv(raw, file,row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
})