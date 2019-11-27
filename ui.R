library(shiny)
library(GGally)
library(caTools)
library(caret)
library(e1071)
library(pROC)
library(DT)


vchoices = c("Pregnancies","Glucose","BloodPressure","SkinThickness","Insulin","BMI","DiabetesPedigreeFunction","Age")


library(markdown)

navbarPage("Menu",
           
           tabPanel("Introduction",
                    includeMarkdown('introduction.md')
           ),
           tabPanel("Data Exploration",
                    sidebarLayout(
                        sidebarPanel(
                            selectInput('explore_x', 'X Variable', choices=vchoices, selected='BloodPressure'),
                            selectInput('explore_y', 'Y Variable', choices=vchoices, selected='Glucose'),
                            shiny::verbatimTextOutput('DefineTarget')
                        ),
                        mainPanel(
                            plotOutput("explore_plot")
                        )
                    )
           ),
           tabPanel("Data Prep",
                    sidebarLayout(
                        sidebarPanel(
                            checkboxGroupInput("columns","Select Columns",choices=vchoices,inline = T, selected = c('BMI', 'Age')),
                            checkboxGroupInput("replace_0_columns","Replace Zero with Mean",choices=vchoices,inline = T),
                            sliderInput('prep_trainPct', 'Training Percent', 0.1, 0.9, 0.7, step = 0.1),
                            radioButtons('view_train_test', 'Preview Data', choices=c('Train', 'Test'))
                        ),
                        mainPanel(
                          dataTableOutput("prep_view_data")
                          
                        )
                    )
           ),
           tabPanel("Modeling",
                    sidebarLayout(
                      sidebarPanel(
                        sliderInput('cv_number', 'Cross Validation Folds', 2, 10, 5, step = 1),
                        checkboxGroupInput("preprocess","Preprocessing Steps",choices=c('center', 'scale'),inline = T)
                      ),
                      mainPanel(
                        shiny::tableOutput('confusion_matrix'),
                        shiny::plotOutput('plot_roc'),
                        shiny::verbatimTextOutput('model_output')
                      )
                    )
           )
)

