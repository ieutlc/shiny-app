library(shiny)

# Data arrays
pagesperhour <- array(
  c(67,47, 33, 33, 24, 17, 17, 12, 9, 50, 35, 25, 25, 18, 13, 13, 9, 7, 40, 28, 20, 20, 14, 10, 10, 7, 5), 
  dim=c(3,3,3),
  dimnames = list(
    c("No New Concepts","Some New Concepts","Many New Concepts"), 
    c("Survey","Learn","Engage"),
    c("450 Words (Paperback)","600 Words (Monograph)","750 Words (Textbook)")
  )
)

hoursperwriting <- array(
  c(0.75, 1.5, 1, 2, 1.25, 2.5, 1.5, 3, 2, 4, 2.5, 5, 3, 6, 4, 8, 5, 10),
  dim=c(2,3,3),
  dimnames = list(
    c("250 Words (D-Spaced)", "500 Words (S-Spaced)"),
    c("No Drafting", "Minimal Drafting", "Extensive Drafting"),
    c("Reflection; Narrative", "Argument", "Research")
  )
)

shinyServer(function(input, output) {
  
  output$estimatedworkload <- renderText({
    pagesperhour.sel <- if (input$setreadingrate) input$overridepagesperhour else pagesperhour[
      as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)
    ]
    hoursperwriting.sel <- if (input$setwritingrate) input$overridehoursperwriting else hoursperwriting[
      as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)
    ]
    posthours.sel <- if (!input$setdiscussion) {
      if (input$postformat == 1) {
        (input$postlength.text * input$postsperweek) / 250
      } else {
        0.18 * (input$postlength.av * input$postsperweek) + 
          (input$postlength.av * input$postsperweek) / 6
      }
    } else input$overridediscussion
    
    takehome.sel <- if (input$takehome) input$exam.length else 0
    
    expr <- paste(
      "Total:",
      round(
        (input$weeklypages / pagesperhour.sel) +
          (hoursperwriting.sel * input$semesterpages / input$classweeks) +
          (input$exams * input$examhours / input$classweeks) +
          (input$otherassign * input$otherhours / input$classweeks) +
          posthours.sel +
          input$weeklyvideos +
          ((takehome.sel / 60) * input$exams / input$classweeks) +
          (input$syncsessions * input$synclength),
        2
      ),
      "hrs/wk"
    )
    expr
  })
  
  output$estimatedoutofclass <- renderText({
    pagesperhour.sel <- if (input$setreadingrate) input$overridepagesperhour else pagesperhour[
      as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)
    ]
    hoursperwriting.sel <- if (input$setwritingrate) input$overridehoursperwriting else hoursperwriting[
      as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)
    ]
    posthours.sel <- if (!input$setdiscussion) {
      if (input$postformat == 1) {
        (input$postlength.text * input$postsperweek) / 250
      } else {
        (input$postlength.av * input$postsperweek) / 3
      }
    } else input$overridediscussion
    
    takehome.sel <- if (input$takehome) input$exam.length else 0
    other.sel <- if (!input$other.engage) input$otherassign * input$otherhours else 0
    
    expr <- paste(
      "Independent:",
      round(
        (input$weeklypages / pagesperhour.sel) +
          (hoursperwriting.sel * input$semesterpages / input$classweeks) +
          (input$exams * input$examhours / input$classweeks) +
          input$weeklyvideos +
          (other.sel / input$classweeks) +
          ((takehome.sel / 60) * input$exams / input$classweeks),
        2
      ),
      "hrs/wk"
    )
    expr
  })
  
  output$estimatedengaged <- renderText({
    other.sel <- if (input$other.engage) input$otherassign * input$otherhours else 0
    posthours.sel <- if (!input$setdiscussion) {
      if (input$postformat == 1) {
        (input$postlength.text * input$postsperweek) / 250
      } else {
        (input$postlength.av * input$postsperweek) / 3
      }
    } else input$overridediscussion
    
    expr <- paste(
      "Contact:",
      round(
        posthours.sel +
          (input$syncsessions * input$synclength) +
          (other.sel / input$classweeks),
        2
      ),
      "hrs/wk"
    )
    expr
  })
  
  output$hoursperposts.out <- renderText({
    posthours.sel <- if (input$postformat == 1) {
      (input$postlength.text * input$postsperweek) / 250
    } else {
      (input$postlength.av * input$postsperweek) / 3
    }
    expr <- paste(round(posthours.sel, 2), "hours / week")
    expr
  })
  
  output$pagesperhour.out <- renderText({
    expr <- paste(
      pagesperhour[
        as.numeric(input$difficulty), as.numeric(input$readingpurpose), as.numeric(input$readingdensity)
      ],
      "pages per hour"
    )
    expr
  })
  
  output$hoursperwriting.out <- renderText({
    expr <- paste(
      hoursperwriting[
        as.numeric(input$writtendensity), as.numeric(input$draftrevise), as.numeric(input$writingpurpose)
      ],
      "hours per page"
    )
    expr
  })
})
