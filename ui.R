library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinytest)

dashboardPage(
  dashboardHeader(title="Research Activities, Morbidity, and Mortality Rate of Monkeypox Outbreak", 
                  titleWidth=650,
                  tags$li(class="dropdown", tags$a(href="#", icon("github"), "Source Code", target="_blank"))
                  ),
  dashboardSidebar(
    # side bar menu
    sidebarMenu(
          id = "sidebar",
          
          # first menu item
          menuItem("Research Activities Data", tabName="research_data", icon=icon("database")),
          conditionalPanel("input.sidebar == 'research_data' && input.t1=='bars'", selectInput("data", "Choose a database",choices=df_list, selected=df_list[[1]])),
          conditionalPanel("input.sidebar == 'research_data' && input.t1 == 'bars'", selectInput("xcol", "Variable X", c())),
          conditionalPanel("input.sidebar == 'research_data' && input.t1 == 'bars'", selectInput("ycol", "Variable Y", c())),
          menuItem("Morbidity and Mortality Data", tabName="case_data", icon=icon("database")),
          conditionalPanel("input.sidebar == 'case_data' && input.t2 == 'mapping'", selectInput(inputId="maps_data", "Select Variable", choices=maps_vars, selected=maps_vars[[1]]))
          
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName="research_data", 
              tabBox(id="t1", width=20,
                     tabPanel("About", icon=icon("address-card"), fluidRow(
                       column(width=8, tags$img(src="monkeypox_particles.jpg", width=600, height=300),
                              tags$br(),
                              tags$a("Colorized transmission electron micrograph of monkeypox particles (teal) found within an infected cell (brown), cultured in the laboratory. Image captured and color-enhanced at the NIAID Integrated Research Facility (IRF) in Fort Detrick, Maryland. Credit: NIAID"), align="center"),
                       column(width=4, 
                              tags$br(),
                              tags$p("Welcome. This interactive page allows you to access visualization of research activities being carried out by various research agencies and the progress of the research activities. The dataset used here contains critical research areas that allows for comprehension of the research activities related to the mpox outbreak."))
                     )),
                     tabPanel("Visualization", icon=icon("address-card"), value="bars", withSpinner(plotlyOutput("barplot"))),
                     tabPanel("Data", icon=icon("address-card"), dataTableOutput("research_table")),
                     tabPanel("Structure", icon=icon("address-card"), verbatimTextOutput("research_structure"))
                     )),
      tabItem(tabName="case_data", 
              tabBox(id="t2", width=12,
                     tabPanel("About", icon=icon("address-card"), fluidRow(
                       column(width=8, tags$img(src="monkeypox_spread.png", width=600, height=300),
                              tags$br(),
                              tags$a("Photo by Ranjit Sah"), align="center"),
                       column(width=4, tags$br(),
                              tags$p("Welcome. In this page you will be able to visualize the prevelence and mortality rate of Monkepox virus globally."))
                     )),
                     tabPanel("Visualization", icon=icon("address-card"), value="mapping", withSpinner(plotlyOutput("map_plot"))),
                     tabPanel("Data", icon=icon("address-card"), dataTableOutput("case_table")),
                     tabPanel("Summary", icon=icon("address-card"), verbatimTextOutput("case_structure")),
              ))
    )
  )
)
