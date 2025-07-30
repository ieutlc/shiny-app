library(shiny)

shinyUI(
  fluidPage(
    
    # Head content
    tags$head(
      # includeScript("google-analytics.js"),  # devre dışı bırakıldı
      tags$style("body { max-width: 960px; margin: auto; }")
    ),
    
    # Başlık ve kaynak linkleri
    h3("Enhanced Course Workload Estimator", align = "center"),
    
    hr(),
    
    fluidRow(
      
      column(3,
             h5("COURSE INFO", align = "center"),
             wellPanel(
               numericInput("classweeks", "Class Duration (Weeks):", value = 15, width = '100%')
             ),
             
             h5("READING ASSIGNMENTS", align = "center"),
             wellPanel(
               numericInput("weeklypages", "Pages Per Week:", value = 0, width = '100%'),
               hr(),
               selectInput("readingdensity", "Page Density:", c("450 Words" = 1, "600 Words" = 2, "750 Words" = 3), selected = 1),
               selectInput("difficulty", "Difficulty:", c("No New Concepts" = 1, "Some New Concepts" = 2, "Many New Concepts" = 3), selected = 1),
               selectInput("readingpurpose", "Purpose:", c("Survey" = 1, "Understand" = 2, "Engage" = 3), selected = 1),
               p(strong("Estimated Reading Rate:"), br(), textOutput("pagesperhour.out", inline = T), br(), br(),
                 checkboxInput("setreadingrate", "manually adjust", value = FALSE, width = '100%'), align = "center"),
               conditionalPanel("input.setreadingrate == true",
                                numericInput("overridepagesperhour", "Pages Read Per Hour:", value = 10, min = 0, width = '100%')
               )
             )
      ),
      
      column(3,
             h5("WRITING ASSIGNMENTS", align = "center"),
             wellPanel(
               numericInput("semesterpages", "Pages Per Semester:", value = 0, width = '100%'),
               hr(),
               selectInput("writtendensity", "Page Density:", c("250 Words" = 1, "500 Words" = 2), selected = 1),
               selectInput("writingpurpose", "Genre:", c("Reflection/Narrative" = 1, "Argument" = 2, "Research" = 3), selected = 1),
               selectInput("draftrevise", "Drafting:", c("No Drafting" = 1, "Minimal Drafting" = 2, "Extensive Drafting" = 3), selected = 1),
               p(strong("Estimated Writing Rate:"), br(), textOutput("hoursperwriting.out", inline = T), br(), br(),
                 checkboxInput("setwritingrate", "manually adjust", value = FALSE, width = '100%'), align = "center"),
               conditionalPanel("input.setwritingrate == true",
                                numericInput("overridehoursperwriting", "Hours Per Written Page:", value = 0.5, min = 0.1, width = '100%')
               )
             ),
             
             h5("VIDEOS / PODCASTS", align = "center"),
             wellPanel(
               numericInput("weeklyvideos", "Hours Per Week:", value = 0, width = '100%')
             )
      ),
      
      column(3,
             h5("DISCUSSION POSTS", align = "center"),
             wellPanel(
               numericInput("postsperweek", "Posts per Week:", value = 0, width = '100%'),
               hr(),
               selectInput("postformat", "Format:", c("Text" = 1, "Audio/Video" = 2), selected = 1),
               conditionalPanel("input.postformat == 1",
                                numericInput("postlength.text", "Avg. Length (Words):", value = 250, min = 0, width = '100%')
               ),
               conditionalPanel("input.postformat == 2",
                                numericInput("postlength.av", "Avg. Length (Minutes):", value = 3, min = 0, width = '100%')
               ),
               p(strong("Estimated Hours:"), br(), textOutput("hoursperposts.out", inline = T), br(), br(),
                 checkboxInput("setdiscussion", "manually adjust", value = FALSE, width = '100%'), align = "center"),
               conditionalPanel("input.setdiscussion == true",
                                numericInput("overridediscussion", "Hours Per Week:", value = 1, min = 0, width = '100%')
               )
             ),
             
             h5("EXAMS", align = "center"),
             wellPanel(
               numericInput("exams", "Exams Per Semester:", value = 0, width = '100%'),
               numericInput("examhours", "Study Hours Per Exam:", value = 5, min = 0, max = 50, width = '100%'),
               checkboxInput("takehome", "Take-Home Exams", value = FALSE, width = '100%'),
               conditionalPanel("input.takehome == true",
                                numericInput("exam.length", "Exam Time Limit (Minutes):", value = 60, min = 0, width = '100%')
               )
             )
      ),
      
      column(3,
             h5("OTHER ASSIGNMENTS", align = "center"),
             wellPanel(
               numericInput("otherassign", "# Per Semester:", value = 0, width = '100%'),
               sliderInput("otherhours", "Hours Per Assignment:", min = 0, max = 50, step = 1, value = 0, width = '100%'),
               checkboxInput("other.engage", "Independent", value = FALSE, width = '100%')
             ),
             
             h5("CLASS MEETINGS", align = "center"),
             wellPanel(
               numericInput("syncsessions", "Live Meetings Per Week:", value = 0, width = '100%'),
               numericInput("synclength", "Meeting Length (Hours):", value = 0, width = '100%')
             ),
             
             hr(),
             h5("WORKLOAD ESTIMATES", align = "center"),
             wellPanel(
               p(strong(textOutput("estimatedworkload", inline = T)), align = "right"),
               p(strong(textOutput("estimatedoutofclass", inline = T)), align = "right"),
               p(strong(textOutput("estimatedengaged", inline = T)), align = "right")
             )
      )
    ),
    
  )
)
