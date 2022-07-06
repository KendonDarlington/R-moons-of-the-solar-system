#Import our libraries
library(shiny)
library(tidyverse)
library(shinythemes)
library(reactable)

#The ui is the front end
ui <- fluidPage(theme = shinytheme("darkly"),
    
    #Jumbotrons are pretty, they make nice headers
    tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
             tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'Moons Of The Solar System'),
             p('Learn about the planets and their moons through the power of R!')
    ),
    
    #Select Inputs are dropdowns. This one is filled with planets!
    selectInput("selectPlanet", h4("Select A Planet"), 
                choices = list(#"All" = "Sun", 
                               "Earth" = "Earth",
                               "Mars" = "Mars",
                               "Jupiter" = "Jupiter",
                               "Saturn" = "Saturn",
                               "Uranus" = "Uranus",
                               "Neptune" = "Neptune",
                               "Pluto" = "Pluto"
                               ), selected = "1"),
    
    #I want the planets next to the reactable, so we make a row with 2 columns to hold them.
    fluidRow(
      column(4,
             #This is the drawing
             imageOutput("planetDrawings")
      ),
      column(8,
             #This is the table
             reactableOutput("moons")
             )
    )
)

#The server is the back end
server <- function(input, output) {
  
  #This looks in our dropdown and returns the appropriate image
  output$planetDrawings <- renderImage({
    
    #Take the planet name and build a path to the image (eg 'Earth' becomes 'Earth.png')
    planet <- input$selectPlanet
    picFilepath <- paste(planet,'.png', sep='')
    
    #This nonsense is what you have to do to render an image from the server
    return(list(
      src=picFilepath,
      contentType = 'image/png',
      alt = 'Planet'
    ))
  })
  
  #Import our csv of moons
  df <- read_csv('MoonsOfTheSolarSystem.csv')
  
  #This looks for our planet 
  output$moons <- renderReactable({
    
    #Lets use options to style our reactable to match our dark theme.
    options(reactable.theme = reactableTheme(
      color = "hsl(233, 9%, 87%)",
      backgroundColor = "hsl(233, 9%, 19%)",
      borderColor = "hsl(233, 9%, 22%)",
      stripedColor = "hsl(233, 12%, 22%)",
      highlightColor = "hsl(233, 12%, 24%)",
      inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
    ))
    
    #Here is the actual reactable. Just a little bit of tidyverse here to filter our df to the selected planet.
    reactable(df %>% 
                filter(Parent == input$selectPlanet))
  })
}

#Run the app
shinyApp(ui = ui, server = server)
