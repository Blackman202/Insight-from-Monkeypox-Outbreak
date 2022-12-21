function(input, output, session){
  
  # Structure
  output$research_structure <- renderPrint(
    # data structure
    research_data %>%
      str()
  )
  
  output$research_table <- renderDataTable(
    research_data
  )
  
  # Structure
  output$case_structure <- renderPrint(
    summary(location_cases)
    
  )
  
  output$case_table <- renderDataTable(
    location_cases
  )
  
  mydata <- eventReactive(input$data, {
    get(input$data)
  })
  
  
  observeEvent(input$data, {
    req(mydata())
    choices <- names(mydata())
    updateSelectInput(session,"xcol",choices = choices, selected=choices[1])
    updateSelectInput(session,"ycol",choices = choices, selected=choices[2])
  }, ignoreNULL = FALSE)
  
  output$barplot <- renderPlotly({
    req(mydata(), input$xcol, input$ycol)
    if (is.null(mydata()) | !(input$xcol %in% colnames(mydata())) | !(input$ycol %in% colnames(mydata())) ) {
      return(NULL)
    } else{
      selected_df <- mydata() %>%
        ggplot(aes(x=get(input$xcol), y=get(input$ycol)))+
        geom_bar(stat = 'identity', width=0.5, )+
        xlab(colnames(mydata()[1]))+
        ylab("Frequency")+
        theme(axis.text.x = element_text(angle = 90),
              rect=element_blank())+
        ggtitle(paste("Frequency of ", colnames(mydata()[1])))
    }
  })
  
  
  output$map_plot <- renderPlotly({
    mapped_locations %>%
    ggplot(aes(x=long, y=lat, group=group))+
      geom_polygon(aes(fill=get(input$maps_data)), color="grey")+
      scale_fill_gradient(name=paste(input$maps_data), low="#d3a500", high="#ff0f00", na.value="royalblue")+
      theme(axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.y=element_blank(),
              axis.title.x=element_blank(),
              rect=element_blank())+
      labs(title=paste("Reported", input$maps_data, "per Country"))
      
  })
  
  
  
}
